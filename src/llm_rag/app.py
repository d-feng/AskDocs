import streamlit as st
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain_community.vectorstores import FAISS
from langchain_community.document_loaders import TextLoader, Docx2txtLoader
from langchain_text_splitters import CharacterTextSplitter
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.messages import HumanMessage, AIMessage
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
import os
import json
from datetime import datetime
from pathlib import Path
from dotenv import load_dotenv

# Load .env from project root regardless of where streamlit is launched from
load_dotenv(Path(__file__).parent.parent.parent / ".env", override=True)

VECTOR_STORE_DIR = os.getenv("VECTOR_STORE_DIR", "vector_store")
SESSIONS_DIR = os.path.join(VECTOR_STORE_DIR, "chat_sessions")
os.makedirs(VECTOR_STORE_DIR, exist_ok=True)
os.makedirs(SESSIONS_DIR, exist_ok=True)

FILES_MANIFEST = os.path.join(VECTOR_STORE_DIR, "processed_files.json")


def save_file_manifest():
    with open(FILES_MANIFEST, "w") as f:
        json.dump(st.session_state.processed_files, f)


def load_file_manifest():
    if os.path.exists(FILES_MANIFEST):
        with open(FILES_MANIFEST) as f:
            return json.load(f)
    return []


def list_sessions():
    """Return saved session names sorted newest-first."""
    files = sorted(Path(SESSIONS_DIR).glob("*.json"), reverse=True)
    return [f.stem for f in files]


def save_session(name: str):
    """Save current messages to a named session file."""
    name = name.strip() or datetime.now().strftime("%Y-%m-%d_%H-%M")
    path = os.path.join(SESSIONS_DIR, f"{name}.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump({"name": name, "messages": st.session_state.messages}, f, ensure_ascii=False, indent=2)
    return name


def load_session(name: str):
    """Load messages from a saved session file."""
    path = os.path.join(SESSIONS_DIR, f"{name}.json")
    if os.path.exists(path):
        with open(path, encoding="utf-8") as f:
            data = json.load(f)
        return data.get("messages", [])
    return []


def delete_session(name: str):
    path = os.path.join(SESSIONS_DIR, f"{name}.json")
    if os.path.exists(path):
        os.remove(path)


def initialize_session_state():
    if "messages" not in st.session_state:
        st.session_state.messages = []
    if "vectorstore" not in st.session_state:
        st.session_state.vectorstore = None
    if "processed_files" not in st.session_state:
        st.session_state.processed_files = load_file_manifest()
    if "active_session" not in st.session_state:
        st.session_state.active_session = None

def process_document(uploaded_file):
    """Process document and update vectorstore"""
    # Save uploaded file temporarily
    with open(uploaded_file.name, "wb") as f:
        f.write(uploaded_file.getbuffer())
    
    # Load document based on file type
    if uploaded_file.name.endswith('.txt'):
        loader = TextLoader(uploaded_file.name)
    elif uploaded_file.name.endswith('.docx'):
        loader = Docx2txtLoader(uploaded_file.name)
    else:
        raise ValueError("Unsupported file format")
    
    documents = loader.load()
    
    # Split documents into chunks
    chunk_size = int(os.getenv("CHUNK_SIZE", "1000"))
    chunk_overlap = int(os.getenv("CHUNK_OVERLAP", "200"))
    text_splitter = CharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
    texts = text_splitter.split_documents(documents)
    
    # Create or update vectorstore
    embeddings = OpenAIEmbeddings()
    
    if st.session_state.vectorstore is None:
        # Create new vectorstore if none exists
        vectorstore = FAISS.from_documents(texts, embeddings)
    else:
        # Add new texts to existing vectorstore
        st.session_state.vectorstore.add_documents(texts)
        vectorstore = st.session_state.vectorstore
    
    # Save vectorstore
    save_path = os.path.join(VECTOR_STORE_DIR, "combined_vectorstore.faiss")
    vectorstore.save_local(save_path)
    
    # Clean up temporary file
    os.remove(uploaded_file.name)
    
    if uploaded_file.name not in st.session_state.processed_files:
        st.session_state.processed_files.append(uploaded_file.name)
        save_file_manifest()

    return vectorstore

def load_vectorstore():
    """Load combined vectorstore from disk"""
    save_path = os.path.join(VECTOR_STORE_DIR, "combined_vectorstore.faiss")
    if os.path.exists(save_path):
        embeddings = OpenAIEmbeddings()
        return FAISS.load_local(
            save_path, 
            embeddings,
            allow_dangerous_deserialization=True  # Only use this if you trust the source of the vector store
        )
    return None

def get_conversation_chain(vectorstore):
    """Build a RAG chain using only langchain_core (no langchain base package required)."""
    model = os.getenv("OPENAI_MODEL", "gpt-4o")
    llm = ChatOpenAI(model=model, temperature=0.7)
    retriever = vectorstore.as_retriever()

    def format_docs(docs):
        return "\n\n".join(doc.page_content for doc in docs)

    prompt = ChatPromptTemplate.from_messages([
        ("system", "Answer the question using only the context below.\n\n{context}"),
        MessagesPlaceholder("chat_history"),
        ("human", "{input}"),
    ])

    chain = (
        RunnablePassthrough.assign(
            context=lambda x: format_docs(retriever.invoke(x["input"]))
        )
        | prompt
        | llm
        | StrOutputParser()
    )
    return chain


def handle_user_input(user_question):
    """Handle user input and generate response."""
    if st.session_state.vectorstore:
        chain = get_conversation_chain(st.session_state.vectorstore)

        chat_history = []
        for msg in st.session_state.messages:
            if msg["role"] == "user":
                chat_history.append(HumanMessage(content=msg["content"]))
            else:
                chat_history.append(AIMessage(content=msg["content"]))

        answer = chain.invoke({"input": user_question, "chat_history": chat_history})

        st.session_state.messages.append({"role": "user", "content": user_question})
        st.session_state.messages.append({"role": "assistant", "content": answer})

CLAUDE_CSS = """
<style>
/* ── Hide default Streamlit chrome ── */
#MainMenu, footer, header { visibility: hidden; }

/* ── Typography ── */
html, body, [class*="css"] {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
                 "Helvetica Neue", Arial, sans-serif;
}

/* ── Page background ── */
.stApp { background-color: #ffffff; }

/* ── Sidebar ── */
section[data-testid="stSidebar"] {
    background-color: #f5f5f4;
    border-right: 1px solid #e7e5e4;
    padding-top: 1rem;
}
section[data-testid="stSidebar"] h1,
section[data-testid="stSidebar"] h2,
section[data-testid="stSidebar"] h3 {
    color: #1c1917;
    font-size: 0.85rem;
    font-weight: 600;
    letter-spacing: 0.05em;
    text-transform: uppercase;
}
section[data-testid="stSidebar"] .stFileUploader {
    border: 1.5px dashed #d6d3d1;
    border-radius: 10px;
    background: #fafaf9;
    padding: 0.5rem;
}

/* ── App header bar ── */
.claude-header {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 1.2rem 0 0.5rem 0;
    border-bottom: 1px solid #e7e5e4;
    margin-bottom: 1rem;
}
.claude-header .logo {
    width: 32px; height: 32px;
    background: #D97706;
    border-radius: 6px;
    display: flex; align-items: center; justify-content: center;
    color: white; font-weight: 700; font-size: 16px;
}
.claude-header h1 {
    font-size: 1.15rem;
    font-weight: 600;
    color: #1c1917;
    margin: 0;
}

/* ── Empty state ── */
.empty-state {
    text-align: center;
    padding: 4rem 2rem;
    color: #78716c;
}
.empty-state h2 {
    font-size: 1.4rem;
    font-weight: 600;
    color: #1c1917;
    margin-bottom: 0.5rem;
}
.empty-state p { font-size: 0.95rem; margin: 0; }

/* ── Chat messages ── */
[data-testid="stChatMessage"] {
    border-radius: 12px;
    padding: 4px 8px;
    margin-bottom: 2px;
    border: none !important;
    box-shadow: none !important;
}
/* User bubble — warm gray */
[data-testid="stChatMessage"]:has([data-testid="chatAvatarIcon-user"]) {
    background-color: #f5f5f4;
}
/* Assistant — no background */
[data-testid="stChatMessage"]:has([data-testid="chatAvatarIcon-assistant"]) {
    background-color: transparent;
}
/* Avatar icons */
[data-testid="chatAvatarIcon-user"] {
    background-color: #D97706 !important;
    color: white !important;
    border-radius: 6px !important;
}
[data-testid="chatAvatarIcon-assistant"] {
    background-color: #1c1917 !important;
    color: white !important;
    border-radius: 6px !important;
}

/* ── Chat input ── */
[data-testid="stChatInput"] {
    border: 1.5px solid #e7e5e4 !important;
    border-radius: 24px !important;
    background: #ffffff !important;
    box-shadow: 0 2px 16px rgba(0,0,0,0.07) !important;
    padding: 4px 8px !important;
}
[data-testid="stChatInput"]:focus-within {
    border-color: #D97706 !important;
    box-shadow: 0 0 0 3px rgba(217,119,6,0.12) !important;
}

/* ── Spinner / success / warning ── */
.stAlert { border-radius: 10px; }

/* ── Buttons ── */
.stButton > button {
    border-radius: 8px;
    border: 1px solid #e7e5e4;
    background: #ffffff;
    color: #1c1917;
    font-size: 0.85rem;
    font-weight: 500;
    padding: 6px 14px;
    transition: background 0.15s;
}
.stButton > button:hover {
    background: #f5f5f4;
    border-color: #d6d3d1;
}
</style>
"""


def main():
    st.set_page_config(
        page_title="AskDocs",
        page_icon="💬",
        layout="wide",
        initial_sidebar_state="expanded",
    )
    st.markdown(CLAUDE_CSS, unsafe_allow_html=True)
    initialize_session_state()

    if st.session_state.vectorstore is None:
        st.session_state.vectorstore = load_vectorstore()

    # ── Sidebar ────────────────────────────────────────────────────────────
    with st.sidebar:
        st.markdown("### 💬 AskDocs")
        st.markdown("---")

        st.markdown("**Upload documents**")
        uploaded_file = st.file_uploader(
            "TXT or DOCX",
            type=["txt", "docx"],
            label_visibility="collapsed",
        )
        if uploaded_file:
            if uploaded_file.name in st.session_state.processed_files:
                st.warning("Already in knowledge base.")
            else:
                with st.spinner("Embedding…"):
                    st.session_state.vectorstore = process_document(uploaded_file)
                st.success("Added to knowledge base!")

        if st.session_state.processed_files:
            st.markdown("---")
            st.markdown("**Knowledge base**")
            for f in st.session_state.processed_files:
                st.markdown(f"📄 `{f}`")

        # ── Save current chat ──────────────────────────────────────────
        st.markdown("---")
        st.markdown("**Chat sessions**")

        if st.session_state.messages:
            default_name = datetime.now().strftime("%Y-%m-%d %H:%M")
            session_name = st.text_input(
                "Session name",
                value=st.session_state.active_session or default_name,
                label_visibility="collapsed",
                placeholder="Session name…",
                key="session_name_input",
            )
            if st.button("💾 Save chat", use_container_width=True):
                saved = save_session(session_name)
                st.session_state.active_session = saved
                st.success(f'Saved as "{saved}"')

        # ── Load a previous session ────────────────────────────────────
        sessions = list_sessions()
        if sessions:
            selected = st.selectbox(
                "Load session",
                options=["— select —"] + sessions,
                label_visibility="collapsed",
                key="session_load_select",
            )
            col1, col2 = st.columns(2)
            with col1:
                if st.button("📂 Load", use_container_width=True, disabled=(selected == "— select —")):
                    st.session_state.messages = load_session(selected)
                    st.session_state.active_session = selected
                    st.rerun()
            with col2:
                if st.button("🗑 Delete", use_container_width=True, disabled=(selected == "— select —")):
                    delete_session(selected)
                    if st.session_state.active_session == selected:
                        st.session_state.active_session = None
                    st.rerun()

        st.markdown("---")
        if st.button("🗑 Clear chat", use_container_width=True):
            st.session_state.messages = []
            st.session_state.active_session = None
            st.rerun()

        st.markdown(
            "<div style='position:absolute;bottom:1rem;left:1rem;"
            "font-size:0.72rem;color:#a8a29e;'>Powered by OpenAI + FAISS</div>",
            unsafe_allow_html=True,
        )

    # ── Main area ──────────────────────────────────────────────────────────
    session_label = (
        f" · <span style='color:#78716c;font-weight:400;font-size:0.95rem'>{st.session_state.active_session}</span>"
        if st.session_state.active_session else ""
    )
    st.markdown(
        f'<div class="claude-header">'
        f'<div class="logo">A</div>'
        f"<h1>AskDocs{session_label}</h1>"
        f"</div>",
        unsafe_allow_html=True,
    )

    if not st.session_state.vectorstore:
        st.markdown(
            '<div class="empty-state">'
            "<h2>No knowledge base loaded</h2>"
            "<p>Upload a document from the sidebar to get started,<br>"
            "or run <code>python scripts/build_vectorstore.py</code> to load the full knowledge base.</p>"
            "</div>",
            unsafe_allow_html=True,
        )
    else:
        for message in st.session_state.messages:
            with st.chat_message(message["role"]):
                st.markdown(message["content"])

        if not st.session_state.messages:
            st.markdown(
                '<div class="empty-state">'
                "<h2>What would you like to know?</h2>"
                "<p>Ask anything about your uploaded documents.</p>"
                "</div>",
                unsafe_allow_html=True,
            )

        if user_question := st.chat_input("Ask about your documents…"):
            handle_user_input(user_question)
            st.rerun()


if __name__ == "__main__":
    main()