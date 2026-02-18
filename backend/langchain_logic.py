# import os
# import re
# import requests
# from dotenv import load_dotenv
# from ddgs import DDGS

# load_dotenv()

# # --- CONFIGURATION ---
# API_KEY = os.getenv("GEMINI_API_KEY")
# MODEL_ID = "gemini-2.0-flash" 
# GEMINI_URL = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL_ID}:generateContent"

# def call_gemini(prompt):
#     """Internal helper to talk to Gemini API"""
#     headers = {"Content-Type": "application/json"}
#     payload = {"contents": [{"parts": [{"text": prompt}]}]}
#     try:
#         response = requests.post(f"{GEMINI_URL}?key={API_KEY}", headers=headers, json=payload, timeout=15)
#         response.raise_for_status()
#         data = response.json()
#         return data["candidates"][0]["content"]["parts"][0]["text"]
#     except Exception as e:
        # return f"ERROR: {str(e)}"
import os
import re
import requests
from dotenv import load_dotenv
from ddgs import DDGS

load_dotenv()

# --- CONFIGURATION ---
API_KEY = os.getenv("GEMINI_API_KEY")
MODEL_ID = "gemini-2.0-flash" 
GEMINI_URL = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL_ID}:generateContent"

def call_gemini(prompt):
    """Internal helper to talk to Gemini API"""
    headers = {"Content-Type": "application/json"}
    payload = {"contents": [{"parts": [{"text": prompt}]}]}
    try:
        # Added a 10s timeout to prevent Flutter from waiting forever
        response = requests.post(f"{GEMINI_URL}?key={API_KEY}", headers=headers, json=payload, timeout=10)
        response.raise_for_status()
        data = response.json()
        return data["candidates"][0]["content"]["parts"][0]["text"]
    except Exception as e:
        return f"ERROR: {str(e)}"

TECH_KEYWORDS = [
    "rom", "firmware", "flash", "android", "ios",
    "api", "python", "java", "flutter", "c++",
    "linux", "windows", "server", "database",
    "cpu", "gpu", "hardware", "software", "network",
    "programming", "code", "bug", "error", "install",
     # --- Firmware & Mobile ---
    "rom", "firmware", "flash", "bootloader", "root", "custom rom",
    "android", "ios", "recovery", "twrp", "adb", "fastboot", "kernel",

    # --- Programming Languages ---
    "python", "java", "c", "c++", "c#", "dart", "javascript", "typescript",
    "php", "ruby", "go", "rust", "kotlin", "swift", "scala", "perl",

    # --- Frameworks & Libraries ---
    "flutter", "react", "angular", "vue", "django", "flask", "spring",
    "node", "express", "nextjs", "nuxt", "laravel", "bootstrap", "tailwind",

    # --- Software Engineering ---
    "api", "sdk", "library", "framework", "microservices", "backend",
    "frontend", "fullstack", "rest", "graphql", "http", "json", "xml",

    # --- Databases ---
    "database", "sql", "mysql", "postgresql", "sqlite", "mongodb",
    "redis", "nosql", "index", "query", "schema", "migration",

    # --- Operating Systems ---
    "linux", "windows", "macos", "ubuntu", "debian", "fedora",
    "kernel", "terminal", "shell", "bash", "powershell",

    # --- DevOps & Cloud ---
    "docker", "kubernetes", "container", "ci/cd", "pipeline",
    "aws", "azure", "gcp", "cloud", "serverless", "nginx", "apache",

    # --- Hardware ---
    "cpu", "gpu", "ram", "ssd", "hdd", "motherboard", "processor",
    "overclock", "bios", "uefi", "chipset",

    # --- Networking ---
    "network", "ip", "dns", "tcp", "udp", "http", "https", "router",
    "firewall", "vpn", "proxy", "bandwidth", "latency",

    # --- Cybersecurity ---
    "encryption", "hashing", "authentication", "authorization",
    "jwt", "oauth", "ssl", "tls", "vulnerability", "exploit",
    "malware", "ransomware", "phishing",

    # --- AI & Data ---
    "machine learning", "deep learning", "neural network",
    "tensorflow", "pytorch", "nlp", "computer vision",
    "dataset", "training", "model", "algorithm",

    # --- Debugging & Errors ---
    "bug", "error", "exception", "crash", "stack trace",
    "debug", "log", "memory leak", "performance", "optimize",

    # --- Version Control ---
    "git", "github", "gitlab", "commit", "branch", "merge",
    "pull request", "repository", "clone",

    # --- Build & Tools ---
    "compiler", "interpreter", "build", "gradle", "maven",
    "npm", "pip", "yarn", "webpack", "vite",

    # --- General Tech Terms ---
    "software", "hardware", "technology", "automation",
    "virtualization", "virtual machine", "vm", "hypervisor",
    "blockchain", "cryptocurrency", "iot", "embedded system"
     "TV","AC","Smart Watch","Air Fryer","Home Appliances "
]


NON_TECH_KEYWORDS = [
    "cook", "recipe", "food", "restaurant", "hotel", "movie",
    "song", "celebrity", "price", "buy", "review", "travel",
    "tourism", "sports", "match", "cricket", "football",
    "diet", "health tips", "beauty", "fashion"
    # 🍔 Food & Cooking
    "cook", "cooking", "recipe", "recipes", "bake", "baking", "food",
    "meal", "dish", "dinner", "lunch", "breakfast", "snack", "restaurant",
    "hotel food", "street food", "kitchen", "chef", "grill", "boil", "fry",

    # 🎬 Entertainment & Media
    "movie", "movies", "film", "cinema", "series", "tv show", "netflix",
    "actor", "actress", "celebrity", "gossip", "trailer", "review",
    "song", "songs", "music", "singer", "album", "lyrics", "concert",

    # 🏖 Travel & Places
    "travel", "trip", "tour", "vacation", "holiday", "hotel", "resort",
    "beach", "mountain", "tourist", "flight", "train ticket", "bus ticket",
    "destination", "places to visit",

    # 🛍 Shopping & Prices
    "buy", "price", "cheap", "discount", "offer", "deal", "sale",
    "best price", "online shopping", "amazon", "flipkart", "store",
    "shop", "mall", "cost", "compare price",

    # 🏋 Health & Fitness (non-tech)
    "diet", "weight loss", "exercise", "workout", "gym", "yoga",
    "fitness tips", "health tips", "nutrition", "protein",
    "calories", "bodybuilding",

    # 💄 Beauty & Fashion
    "makeup", "skincare", "haircare", "hairstyle", "fashion",
    "dress", "clothes", "outfit", "shoes", "jewelry", "style",
    "cosmetics", "lipstick", "perfume",

    # ⚽ Sports
    "cricket", "football", "soccer", "match", "score", "tournament",
    "world cup", "ipl", "player stats", "team ranking",
    "basketball", "tennis", "badminton",

    # 🧘 Lifestyle & Personal
    "relationship", "dating", "marriage", "love tips",
    "motivation", "life advice", "success story",
    "horoscope", "astrology", "zodiac", "dream meaning",

    # 🧒 Education (non-tech topics)
    "history", "geography", "politics", "economics",
    "psychology", "philosophy", "literature",
    "poem", "novel", "story",

    # 🎉 Events & Fun
    "party", "wedding", "birthday", "festival", "celebration",
    "decoration", "gift ideas",

    # 🏠 Home & Daily Life
    "cleaning", "home decor", "furniture", "gardening",
    "plants", "flowers", "pets", "dog care", "cat care",
    "house tips"
]

# def classify_query(query):
#     q = query.lower()

#     # 🚫 Hard block obvious non-tech
#     for word in NON_TECH_KEYWORDS:
#         if word in q:
#             print("BLOCKED NON-TECH:", word)
#             return "NON_TECH"

#     # ✅ Hard allow obvious tech
#     for word in TECH_KEYWORDS:
#         if word in q:
#             print("ALLOWED TECH:", word)
#             return "TECH"

#     # 🧠 Only ambiguous goes to AI
#     prompt = f"""
# Classify as TECH or NON_TECH.
# TECH = technology, software, hardware, IT.
# NON_TECH = lifestyle, food, entertainment.

# Query: {query}
# Answer exactly one word.
# """
#     ai = call_gemini(prompt).strip().upper()

#     print("AI DECISION:", ai)

#     return "TECH" if ai == "TECH" else "NON_TECH"





# def improve_query(query):
#     """Optimizes the query for better search results"""
#     prompt = f"Rewrite this search query to find high-quality technical documentation or StackOverflow solutions: {query}"
#     result = call_gemini(prompt).strip()
#     return query if "ERROR" in result else result

# def search_ddg(query):
#     """Fetches real-time results from DuckDuckGo"""
#     results = []
#     try:
#         with DDGS() as ddgs:
#             # list() ensures we consume the generator safely
#             ddgs_results = list(ddgs.text(query, region='wt-wt', safesearch='moderate', max_results=5))
#             for r in ddgs_results:
#                 results.append({
#                     "title": r.get('title', 'No Title'),
#                     "snippet": r.get('body', 'No Description'),
#                     "url": r.get('href', '')
#                 })
#         return results
#     except Exception as e:
#         print(f"DDG Search Error: {e}")
#         return []

def classify_query(query):
    """Refined for Flutter: Returns clean categories"""
    q = query.lower().strip()

    # 🚫 Hard block obvious non-tech
    for word in NON_TECH_KEYWORDS:
        if word in q:
            return "NON_TECH"

    # ✅ Hard allow obvious tech
    for word in TECH_KEYWORDS:
        if word in q:
            return "TECH"

    # 🧠 AI Decision with cleaning
    prompt = f"Classify this as TECH or NON_TECH only: {query}"
    ai_raw = call_gemini(prompt).strip().upper()
    
    # Regex clean: Removes stars, dots, or extra words like 'The category is TECH'
    ai_clean = re.sub(r'[^A-Z_]', '', ai_raw)

    return "TECH" if "TECH" in ai_clean and "NON" not in ai_clean else "NON_TECH"

def improve_query(query):
    """Optimizes the query for StackOverflow/Docs style results"""
    prompt = f"Convert this into a professional technical search query for StackOverflow: {query}"
    result = call_gemini(prompt).strip()
    # If AI fails, fallback to original query so search still works
    return query if "ERROR" in result or len(result) > 100 else result

def search_ddg(query):
    """Fetches results formatted specifically for Flutter ListViews"""
    results = []
    try:
        with DDGS() as ddgs:
            # max_results=5 is ideal for mobile screens to avoid lag
            ddgs_results = list(ddgs.text(query, region='wt-wt', safesearch='moderate', max_results=5))
            for r in ddgs_results:
                results.append({
                    "title": r.get('title', 'No Title'),
                    "snippet": r.get('body', 'No Description'),
                    "url": r.get('href', '')
                })
        return results
    except Exception as e:
        print(f"DDG Search Error: {e}")
        return []

# import os
# import requests
# from dotenv import load_dotenv
# from ddgs import DDGS

# load_dotenv()

# # --- CONFIGURATION 2026 ---
# API_KEY = os.getenv("GEMINI_API_KEY")

# # Use the latest stable model as of Feb 2026
# MODEL_ID = "gemini-2.0-flash" 

# # Base URL for the Google AI Gemini API
# GEMINI_URL = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL_ID}:generateContent"

# def call_gemini(prompt):
#     """Internal helper to talk to Gemini API"""
#     headers = {"Content-Type": "application/json"}
#     payload = {
#         "contents": [
#             {
#                 "parts": [{"text": prompt}]
#             }
#         ]
#     }
#     try:
#         # Use the key as a query parameter
#         response = requests.post(
#             f"{GEMINI_URL}?key={API_KEY}", 
#             headers=headers, 
#             json=payload, 
#             timeout=15
#         )
        
#         # Check for 404 or 403 errors specifically
#         if response.status_code == 404:
#             return "ERROR: Model not found. Check if gemini-2.0-flash is available in your region."
        
#         response.raise_for_status()
#         data = response.json()
        
#         # Extract text from the new response format
#         return data["candidates"][0]["content"]["parts"][0]["text"]
#     except Exception as e:
#         return f"ERROR: {str(e)}"

# # def classify_query(query):
# #     """Determines if the query is tech-related"""
# #     prompt = (
# #         "You are a filter. Reply only with the word 'TECH' if the following query "
# #         "is about technology, coding, hardware, or software. "
# #         "Reply only with 'NON_TECH' if it is about anything else. "
# #         f"Query: {query}"
# #     )
# #     response = call_gemini(prompt).strip().upper()
# #     return "NON_TECH" if "NON_TECH" in response else "TECH"
# def classify_query(query):
#     """Determines if the query is tech-related with robust label checking"""
#     prompt = (
#         "Classify the following user search query. "
#         "If it is about programming, software, gadgets, hardware, or IT, output 'TECH'. "
#         "If it is about food, sports, lifestyle, or anything else, output 'NON_TECH'. "
#         "Output only the label.\n"
#         f"Query: {query}"
#     )
    
#     # Get the raw response
#     response = call_gemini(prompt).strip().upper()
    
#     # Log it to your terminal so you can see what Gemini is actually saying!
#     print(f"DEBUG: Gemini classified '{query}' as: {response}")

#     # Instead of an exact match, check if 'NON_TECH' exists anywhere in the response
#     if "NON_TECH" in response:
#         return "NON_TECH"
    
#     return "TECH"

# def improve_query(query):
#     """Optimizes the query for better search results"""
#     prompt = (
#         "Act as a senior software engineer. Rewrite this search query to be highly "
#         "technical and optimized for documentation and StackOverflow results. "
#         f"Query: {query}"
#     )
#     result = call_gemini(prompt).strip()
#     # If Gemini fails, fall back to the original query
#     return query if "ERROR" in result else result


# def search_ddg(query):
#     """Fetches real-time results from DuckDuckGo using the 2026 'ddgs' library"""
#     results = []
#     try:
#         with DDGS() as ddgs:
#             # The .text() method now returns a list or generator 
#             # We wrap it in list() to handle the generator warning
#             ddgs_results = list(ddgs.text(
#                 query, 
#                 region='wt-wt', 
#                 safesearch='moderate', 
#                 max_results=5
#             ))
            
#             for r in ddgs_results:
#                 results.append({
#                     "title": r.get('title', 'No Title'),
#                     "snippet": r.get('body', 'No Description available'),
#                     "url": r.get('href', '')
#                 })
#         return results
#     except Exception as e:
#         print(f"DDG Search Error: {e}")
#         return []
    



# import os
# import requests
# from dotenv import load_dotenv

# load_dotenv()

# API_KEY = os.getenv("GEMINI_API_KEY")

# # FIX: Use the updated model version and the direct generation endpoint
# # Options: "gemini-3-flash-preview" (Latest) or "gemini-2.5-flash" (Stable)
# MODEL_ID = "gemini-3-flash-preview"
# URL = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL_ID}:generateContent"

# def call_gemini(prompt):
#     headers = {"Content-Type": "application/json"}
#     payload = {
#         "contents": [
#             {
#                 "parts": [{"text": prompt}]
#             }
#         ]
#     }

#     # Using the key as a query parameter as you did originally
#     r = requests.post(
#         f"{URL}?key={API_KEY}",
#         headers=headers,
#         json=payload,
#         timeout=20
#     )

#     data = r.json()

#     # Direct error handling for the API response
#     if "error" in data:
#         return f"ERROR: {data['error']['message']}"

#     try:
#         return data["candidates"][0]["content"]["parts"][0]["text"]
#     except (KeyError, IndexError):
#         return f"ERROR: Unexpected response format: {data}"

# def classify_query(query):
#     prompt = f"Reply only 'TECH' if this is technology related. Reply only 'NON_TECH' otherwise. Query: {query}"
#     response = call_gemini(prompt).strip().upper()
#     # Check if the response contains our keywords, ignoring extra model chatter
#     if "NON_TECH" in response:
#         return "NON_TECH"
#     return "TECH"

# def improve_query(query):
#     return call_gemini(f"Improve this tech search query professionally: {query}")
# import os
# import requests
# from dotenv import load_dotenv

# load_dotenv()

# API_KEY = os.getenv("GEMINI_API_KEY")
# BING_API_KEY = os.getenv("BING_API_KEY") # Add this to your .env later

# MODEL_ID = "gemini-3-flash-preview"
# URL = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL_ID}:generateContent"

# def call_gemini(prompt):
#     headers = {"Content-Type": "application/json"}
#     payload = {"contents": [{"parts": [{"text": prompt}]}]}
#     r = requests.post(f"{URL}?key={API_KEY}", headers=headers, json=payload, timeout=20)
#     data = r.json()
    
#     if "error" in data:
#         return f"ERROR: {data['error']['message']}"
#     return data["candidates"][0]["content"]["parts"][0]["text"]

# def classify_query(query):
#     prompt = f"Reply only 'TECH' if this is technology related. Reply only 'NON_TECH' otherwise. Query: {query}"
#     response = call_gemini(prompt).strip().upper()
#     return "NON_TECH" if "NON_TECH" in response else "TECH"

# def improve_query(query):
#     return call_gemini(f"Improve this tech search query professionally: {query}")

# def search_bing(query):
#     # If you don't have a Bing key yet, this returns fake data so the app doesn't crash
#     if not BING_API_KEY:
#         return [{"title": "Mock Result", "snippet": "Get a Bing API key to see real results!", "url": "https://bing.com"}]

#     endpoint = "https://api.bing.microsoft.com/v7.0/search"
#     headers = {"Ocp-Apim-Subscription-Key": BING_API_KEY}
#     params = {"q": query, "count": 5}
    
#     response = requests.get(endpoint, headers=headers, params=params)
#     return response.json().get("webPages", {}).get("value", [])