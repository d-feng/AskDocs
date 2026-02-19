# LLM_RAG — Oncology Document Chat (RAG)

A Retrieval-Augmented Generation (RAG) application for oncology indication selection research.
Upload cancer biology documents and ask questions grounded in your own knowledge base.

## What it does

1. **Ingest** — Upload `.docx` or `.txt` files (indication profiles, protocols, frameworks)
2. **Embed** — Chunks are embedded with OpenAI and stored in a local FAISS vector store
3. **Retrieve & Answer** — Questions are answered using the LLM with retrieved document context
4. **Persist** — The vector store survives restarts; new uploads are additive

The pre-built knowledge base under `knowledge/` covers immune cytokine TME profiling,
cancer indication profiles (LUAD, TNBC, RCC, GBM, PAAD, HCC, HNSCC, GEJ, CRC),
EcoTyper ecotype frameworks, and competitive intelligence.

---

## Installation

### Requirements

- Python 3.10 or higher
- A valid [OpenAI API key](https://platform.openai.com/api-keys) (required for embeddings)
- Conda or a Python virtual environment (**do not use the base Anaconda environment** — it has conflicting PyTorch/transformers installs)

### Step 1 — Create a clean environment

**Option A: Conda (recommended)**
```bash
conda create -n llm_rag python=3.11 -y
conda activate llm_rag
```

**Option B: venv**
```bash
python -m venv venv
venv\Scripts\activate        # Windows
source venv/bin/activate     # Mac/Linux
```

### Step 2 — Install dependencies

```bash
pip install streamlit \
            langchain-openai \
            langchain-community \
            langchain-text-splitters \
            langchain-core \
            faiss-cpu \
            python-dotenv \
            docx2txt
```

> **Note:** Do NOT `pip install langchain` (the base package). The app uses only the
> scoped packages above (`langchain-openai`, `langchain-community`, etc.), which avoids
> pulling in `transformers` → `torch` and the DLL errors that come with it on Windows.

### Step 3 — Configure your API key

```bash
copy .env.example .env       # Windows
cp .env.example .env         # Mac/Linux
```

Edit `.env` and fill in your keys:

```
OPENAI_API_KEY=sk-proj-...   # required — used for embeddings
```

> **Important:** The `.env` file must be in the **project root** (`LLM_RAG/.env`).
> The app loads it with an explicit path so it works regardless of where you launch Streamlit from.
> If you have `OPENAI_API_KEY` set as a system/conda environment variable with an old key,
> the `.env` file will override it (`override=True`).

### Step 4 — (Optional) Pre-build the knowledge base vector store

```bash
python scripts/build_vectorstore.py
```

This indexes all `.md` and `.txt` files under `knowledge/` into `vector_store/`.
If you skip this step, you can still upload individual documents through the app UI.

### Step 5 — Launch the app

```bash
streamlit run src/llm_rag/app.py
```

Open [http://localhost:8501](http://localhost:8501) in your browser.

---

## Using the app

1. **Upload a document** — Use the file uploader (`.docx` or `.txt`). The document is chunked, embedded, and added to the vector store.
2. **Ask questions** — Type in the chat box at the bottom of the page and press Enter.
3. **Continue the conversation** — The chat input clears automatically after each message. Just type your next question.
4. **Add more documents** — Upload additional files at any time; they are appended to the existing vector store.
5. **Restart safely** — The vector store is saved to disk and reloaded on restart, so your knowledge base persists.

---

## Environment variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `OPENAI_API_KEY` | Yes | — | OpenAI API key (used for embeddings) |
| `OPENAI_MODEL` | No | `gpt-4o` | OpenAI chat model name |
| `VECTOR_STORE_DIR` | No | `vector_store` | Path to FAISS index directory |
| `CHUNK_SIZE` | No | `1000` | Document chunk size (characters) |
| `CHUNK_OVERLAP` | No | `200` | Overlap between chunks |

---

## Project layout

```
LLM_RAG/
├── src/llm_rag/
│   ├── app.py                # Streamlit entrypoint  ← run this
│   ├── agent_logger.py       # Agent logging utilities
│   └── ecotyper_examples.py  # DEG analysis examples
├── knowledge/
│   ├── indication_profiles/  # Per-cancer .txt profiles (LUAD, RCC, GBM, ...)
│   ├── frameworks/           # Scoring & decision frameworks (.md)
│   ├── tutorials/            # Cell typing, pathway analysis tutorials
│   └── protocols/            # Research protocols & workflows
├── notebooks/                # Exploratory Jupyter notebooks
├── scripts/
│   ├── build_vectorstore.py  # Rebuild FAISS index from knowledge/
│   ├── OS_estimate.R
│   └── OS_estimate_2.R
├── data/                     # Input data files (CSV, JSON)
├── reports/                  # Generated Word reports (not in active code path)
├── assets/                   # Output plots and images
├── vector_store/             # FAISS index (git-ignored; rebuild with scripts/)
├── .env                      # Your local secrets (git-ignored)
├── .env.example              # Template — copy to .env and fill in keys
├── requirements.txt          # Runtime dependencies
├── requirements-dev.txt      # Dev/test dependencies (pytest, jupyter, ruff)
└── pyproject.toml            # Package metadata
```

---

## Troubleshooting

| Error | Fix |
|---|---|
| `ModuleNotFoundError: No module named 'langchain.chains'` | Do not install `langchain` base. Use scoped packages: `pip install langchain-openai langchain-community langchain-text-splitters langchain-core` |
| `DLL initialization routine failed` (torch/c10.dll) | You are in the base Anaconda environment. Create a fresh conda env: `conda create -n llm_rag python=3.11 -y` |
| `AuthenticationError: Incorrect API key` | Your `.env` has a wrong/expired key, or a system env var is overriding it. Check `LLM_RAG/.env` contains a valid `sk-proj-...` key |
| Chat box disappears after first answer | Fixed in current version — uses `st.chat_input` which stays pinned and clears automatically |
| `vector_store/` missing on startup | Run `python scripts/build_vectorstore.py` to build from `knowledge/`, or upload a document through the UI |

---

## Running notebooks

```bash
pip install -r requirements-dev.txt
jupyter notebook notebooks/
```

Key notebooks:
- `Q_Agent.ipynb` / `Q_Agent2.ipynb` — LLM question-answering agents
- `Evals_02.ipynb` — Evaluation framework
- `IO_conference.ipynb` — Immunotherapy conference intelligence

---

## Tech stack

| Layer | Library |
|---|---|
| UI | Streamlit |
| LLM | OpenAI (`gpt-4o`) via `langchain-openai` |
| Embeddings | `OpenAIEmbeddings` |
| Vector store | FAISS (`faiss-cpu`) |
| RAG chain | `langchain-core` LCEL (`RunnablePassthrough`) |
| Document loading | `langchain-community` (TextLoader, Docx2txtLoader) |
