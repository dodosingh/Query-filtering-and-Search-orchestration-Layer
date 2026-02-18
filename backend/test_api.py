from langchain_logic import call_gemini, classify_query

print("--- Testing API Connection ---")
test_resp = call_gemini("Say 'Hello World'")
print(f"API Response: {test_resp}")

print("\n--- Testing Classification ---")
print(f"Query: 'Python loops' -> {classify_query('Python loops')}")
print(f"Query: 'Cooking pasta' -> {classify_query('Cooking pasta')}")