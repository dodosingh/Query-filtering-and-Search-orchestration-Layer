🚀 TechScope AI – Intelligent Tech Query Filtering & Search Interface

An AI-powered domain-specific search interface that filters and processes only technology-related queries using hybrid rule-based and LLM-based intent classification, and retrieves real-time results via DuckDuckGo.

📌 Overview

TechScope AI is an intelligent backend-driven search interface designed to allow only technology-focused queries while blocking non-technical searches such as food, entertainment, lifestyle, and shopping.

The system uses a hybrid approach combining keyword-based scoring and AI-powered semantic understanding to determine user intent. Approved queries are refined for better relevance and forwarded to DuckDuckGo to fetch real-time search results, which are displayed through a Flutter Web frontend.

🧠 How It Works
User Query
   ↓
Rule-Based Intent Scoring
   ↓
AI-Based Semantic Classification (for ambiguous cases)
   ↓
Query Optimization
   ↓
DuckDuckGo Search API
   ↓
Filtered Real-Time Results

✨ Key Features

🔍 Tech-only query filtering

🤖 Hybrid AI + rule-based intent detection

🚫 Automatic blocking of non-technical queries

⚡ Real-time DuckDuckGo search integration

🧠 Query enhancement using LLM

🌐 RESTful backend API with FastAPI

🎨 Flutter Web frontend interface

🛠 Tech Stack

Frontend

Flutter Web

Backend

FastAPI (Python)

AI Layer

Gemini / Local LLM (Hybrid Intent Classification)

Search Provider

DuckDuckGo API

📂 Project Structure
tech_search_project/
│
├── flutter_app/
│   └── frontend UI
│
└── backend/
    ├── main.py
    ├── langchain_logic.py
    ├── search_service.py
    ├── .env
    └── requirements.txt

⚙️ Setup Instructions
🔹 Backend Setup
cd backend
pip install -r requirements.txt
python -m uvicorn main:app --reload


Backend runs at:

http://127.0.0.1:8000

🔹 Frontend Setup
cd flutter_app
flutter pub get
flutter run -d chrome

🧪 API Example
Request
POST /search
{
  "query": "Samsung flash ROM"
}

Response
{
  "status": "success",
  "improved_query": "Samsung flash ROM",
  "results": [
    {
      "title": "...",
      "snippet": "...",
      "url": "..."
    }
  ]
}

🚫 Non-Tech Query Handling

Queries such as:

"How to cook rice"

"Movie reviews"

"Cheap hotel near me"

Are automatically blocked with a validation message.

🎯 Use Cases

Tech-focused search platforms

Developer tools

Learning resources filtering

Domain-specific search systems

AI query orchestration

🚀 Future Enhancements

Result ranking algorithm

Caching popular queries

Search analytics dashboard

Query summarization

User personalization

👨‍💻 Author

Built by [Your Name]

📜 License

Open-source for learning and development purposes.

🏆 Why This Project Matters

This project demonstrates:

✔ Backend API design
✔ AI integration
✔ Hybrid NLP filtering
✔ Real-world search orchestration
✔ Clean architecture
