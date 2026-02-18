import logging
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from langchain_logic import classify_query, improve_query, search_ddg

# --- LOGGING SETUP ---
# This helps you see what's happening in your terminal in real-time
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("TechSearch")

app = FastAPI(
    title="Tech Search Engine API",
    description="A filtered search engine that only allows technical queries."
)

# --- CORS SETUP ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- MODELS ---
class QueryRequest(BaseModel):
    # Added validation: Query must be at least 2 characters long
    query: str = Field(..., min_length=2, description="The search term entered by the user")

@app.get("/")
def home():
    return {
        "status": "online",
        "mode": "Tech-Only",
        "version": "1.0.0"
    }

@app.post("/search")
async def search_endpoint(request_data: QueryRequest):
    user_query = request_data.query.strip()
    logger.info(f"Received query: {user_query}")

    try:
        # 1. Classification Step
        category = classify_query(user_query)
        
        if "ERROR" in category:
            logger.error(f"Classification AI Error: {category}")
            raise HTTPException(status_code=502, detail="AI Classification service unavailable")

        # Handle Non-Tech Queries
        if category == "NON_TECH":
            logger.warning(f"Query REJECTED as Non-Tech: {user_query}")
            return {
                "status": "invalid",
                "message": "This is a Tech-Only search engine. Please ask a technology-related question.",
                "results": []
            }

        # 2. Improvement Step
        # If improvement fails, we still want to search, so we wrap it safely
        try:
            improved = improve_query(user_query)
            logger.info(f"Query improved to: {improved}")
        except Exception as e:
            logger.error(f"Improvement failed: {e}")
            improved = user_query

        # 3. Execution Step (Search)
        results = search_ddg(improved)
        
        return {
            "status": "success",
            "query_type": "TECH",
            "original_query": user_query,
            "improved_query": improved,
            "results": results,
            "count": len(results)
        }

    except HTTPException as he:
        raise he
    except Exception as e:
        logger.critical(f"System Error: {str(e)}")
        return {
            "status": "error", 
            "message": "An unexpected server error occurred."
        }
# from fastapi import FastAPI, HTTPException
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel
# # Ensure these match the function names in your langchain_logic.py
# from langchain_logic import classify_query, improve_query, search_ddg 

# app = FastAPI(title="Tech Search Engine API")

# # --- CORS SETUP ---
# # Crucial for connecting your Flutter/Web frontend to this Python backend
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],  
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# class QueryRequest(BaseModel):
#     query: str

# @app.get("/")
# def home():
#     return {"status": "Backend is running!", "mode": "Tech-Only"}

# @app.post("/search")
# async def search_endpoint(request: QueryRequest):
#     # 1. Classification Step (The Gatekeeper)
#     # This calls your Gemini logic to see if the query is tech-related
#     category = classify_query(request.query)
    
#     # Check for potential API errors first
#     if "ERROR" in category:
#         raise HTTPException(status_code=500, detail=f"AI Service Error: {category}")

#     # If the AI says it's not tech, we STOP here
#     if category == "NON_TECH":
#         return {
#             "status": "invalid",
#             "message": "Please enter a tech-based valid query. This engine only supports technical topics.",
#             "results": []
#         }

#     # 2. Improvement Step (Only runs if the check above passed)
#     # We turn a basic query into a "Senior Engineer" style query
#     improved = improve_query(request.query)

#     # 3. Execution Step
#     # Use search_ddg (DuckDuckGo) as defined in your logic file
#     try:
#         results = search_ddg(improved)
        
#         return {
#             "status": "success",
#             "improved_query": improved,
#             "results": results
#         }
#     except Exception as e:
#         return {
#             "status": "error", 
#             "message": f"Search failed: {str(e)}"
#         }
    














# from fastapi import FastAPI
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel
# from langchain_logic import classify_query, improve_query, search_ddg

# app = FastAPI()

# # --- CORS SETUP ---
# # This allows your Flutter app (even if running on web or emulator) to talk to the backend
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],  # Allows all origins (good for development)
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# class QueryRequest(BaseModel):
#     query: str

# @app.get("/")
# def home():
#     return {"status": "Backend is running!"}

# @app.post("/search")
# async def search_endpoint(request: QueryRequest):
#     # 1. Classification Step
#     category = classify_query(request.query)
    
#     if category == "NON_TECH":
#         return {
#             "status": "invalid",
#             "message": "This is a Tech-Only search engine. Please ask a technology-related question."
#         }

#     # 2. Improvement Step
#     improved_query = improve_query(request.query)

#     # 3. Execution Step
#     raw_results = search_ddg(improved_query)

#     return {
#         "status": "success",
#         "improved_query": improved_query,
#         "results": raw_results
#     }
# from fastapi import FastAPI, HTTPException
# from pydantic import BaseModel
# from langchain_logic import classify_query, improve_query, search_bing

# app = FastAPI()

# class QueryRequest(BaseModel):
#     query: str

# @app.post("/search")
# async def search(request: QueryRequest):
#     # 1. Classify
#     category = classify_query(request.query)
    
#     if "ERROR" in category:
#         raise HTTPException(status_code=500, detail=category)

#     if "NON_TECH" in category:
#         return {
#             "status": "invalid",
#             "message": "Please do a relevant tech search."
#         }

#     # 2. Improve Query
#     improved = improve_query(request.query)

#     # 3. Search Bing
#     try:
#         results = search_bing(improved)
#         return {
#             "status": "success",
#             "improved_query": improved,
#             "results": results
#         }
#     except Exception as e:
#         return {"status": "error", "message": str(e)}

# from fastapi import FastAPI, HTTPException
# from pydantic import BaseModel
# from langchain_logic import classify_query, improve_query, search_bing

# app = FastAPI()

# class QueryRequest(BaseModel):
#     query: str

# @app.post("/search")
# async def search(request: QueryRequest):
#     # 1. Classify
#     category = classify_query(request.query)
    
#     if category == "NON_TECH":
#         return {
#             "status": "invalid",
#             "message": "Please do a relevant tech search"
#         }

#     # 2. Improve
#     improved = improve_query(request.query)

#     # 3. Search
#     results = search_bing(improved)

#     return {
#         "status": "success",
#         "improved_query": improved,
#         "results": results
#     }