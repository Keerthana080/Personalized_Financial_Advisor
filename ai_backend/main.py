from fastapi import FastAPI
from pydantic import BaseModel
from openai import OpenAI
from dotenv import load_dotenv
import os

load_dotenv()

client = OpenAI(
    api_key=os.getenv("GROQ_API_KEY"),
    base_url="https://api.groq.com/openai/v1",
)

app = FastAPI(title="AI Finance Chatbot")


class ChatRequest(BaseModel):
    user_id: str
    question: str
    context: dict


@app.post("/chat")
def chat(req: ChatRequest):
    # Convert context dict to readable text
    context_text = "\n".join(
        f"{key}: {value}" for key, value in req.context.items()
    )

    # 🔒 SYSTEM PROMPT (STRICT RULES)
    system_prompt = """
You are an AI financial advisor inside a mobile app.

STRICT RULES:
- Keep responses SHORT (max 3–4 sentences)
- Be chat-like and conversational
- Give actionable advice only
- Avoid theory, definitions, or long explanations
- Prefer short bullet points when useful
- If more detail is needed, suggest a follow-up question
"""

    # 👤 USER PROMPT (DATA + QUESTION ONLY)
    user_prompt = f"""
User financial data:
{context_text}

User question:
{req.question}
"""

    response = client.responses.create(
        model="meta-llama/llama-4-maverick-17b-128e-instruct",
        input=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ],
    )

    return {
        "response": response.output_text
    }
