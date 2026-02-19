"""
Build the FAISS vector store from all knowledge base files.

Usage:
    python scripts/build_vectorstore.py

Reads all .md and .txt files under knowledge/ and writes the FAISS index to
the directory specified by the VECTOR_STORE_DIR environment variable
(default: vector_store/).
"""

import os
from pathlib import Path
from dotenv import load_dotenv
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import FAISS
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.document_loaders import TextLoader

load_dotenv()

KNOWLEDGE_DIR = Path(__file__).parent.parent / "knowledge"
VECTOR_STORE_DIR = os.getenv("VECTOR_STORE_DIR", "vector_store")
CHUNK_SIZE = int(os.getenv("CHUNK_SIZE", "1000"))
CHUNK_OVERLAP = int(os.getenv("CHUNK_OVERLAP", "200"))


def load_knowledge_files():
    docs = []
    for path in sorted(KNOWLEDGE_DIR.rglob("*")):
        if path.suffix in (".md", ".txt"):
            try:
                loader = TextLoader(str(path), encoding="utf-8")
                docs.extend(loader.load())
                print(f"  loaded: {path.relative_to(KNOWLEDGE_DIR.parent)}")
            except Exception as e:
                print(f"  SKIP {path.name}: {e}")
    return docs


def main():
    print(f"Scanning {KNOWLEDGE_DIR} ...")
    docs = load_knowledge_files()
    print(f"\n{len(docs)} document(s) loaded. Splitting ...")

    splitter = CharacterTextSplitter(chunk_size=CHUNK_SIZE, chunk_overlap=CHUNK_OVERLAP)
    chunks = splitter.split_documents(docs)
    print(f"{len(chunks)} chunks created. Embedding ...")

    embeddings = OpenAIEmbeddings()
    vectorstore = FAISS.from_documents(chunks, embeddings)

    save_path = os.path.join(VECTOR_STORE_DIR, "combined_vectorstore.faiss")
    os.makedirs(VECTOR_STORE_DIR, exist_ok=True)
    vectorstore.save_local(save_path)
    print(f"\nVector store saved to: {save_path}")


if __name__ == "__main__":
    main()
