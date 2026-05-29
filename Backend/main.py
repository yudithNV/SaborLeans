from fastapi import FastAPI, File, UploadFile
from supabase import create_client, Client
import google.generativeai as genai

app = FastAPI()


SUPABASE_URL = "https://qgywxtfrfenfynknfofe.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFneXd4dGZyZmVuZnlua25mb2ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk5Mzc3MjksImV4cCI6MjA5NTUxMzcyOX0.itFK8c2zPf8P9MGo8BZHJDAACTwJcwk1Dibty63wU_Y"
GEMINI_KEY = "AIzaSyDv6689R8HnOF08pksM3HKg6vRcsTiWquE"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
genai.configure(api_key=GEMINI_KEY)

# Lo dejamos con "latest" por ahora
modelo_ia = genai.GenerativeModel('gemini-2.5-flash')
@app.get("/")
def leer_raiz():
    return {"mensaje": "¡Felicidades! Tu servidor backend está vivo 🚀"}

@app.get("/platos")
def obtener_platos():
    respuesta = supabase.table("platos").select("*").execute()
    return respuesta.data

@app.post("/identificar")
async def identificar_plato(foto: UploadFile = File(...)):
    try:
        contenido_foto = await foto.read()
        prompt = """
        Eres un clasificador de comida boliviana. Analiza la imagen y devuelve ÚNICAMENTE 
        la etiqueta correspondiente en minúsculas y con guiones bajos. 
        Opciones permitidas: pique_macho, sopa_de_mani, saltena_pollo, chairo, majadito, silpancho, cunape, helado_canela. 
        Si no es ninguna o no es comida, devuelve: desconocido. 
        No agregues ninguna otra palabra ni signos de puntuación.
        """
        datos_gemini = [prompt, {"mime_type": foto.content_type, "data": contenido_foto}]
        
        respuesta_ia = modelo_ia.generate_content(datos_gemini)
        etiqueta = respuesta_ia.text.strip().lower()
        
        if etiqueta == "desconocido":
            return {"error": "No pudimos reconocer este plato boliviano."}
            
        respuesta_bd = supabase.table("platos").select("*").eq("etiqueta_ia", etiqueta).execute()
        
        if not respuesta_bd.data:
            return {"error": f"La IA reconoció '{etiqueta}', pero no tenemos su receta en la BD."}
            
        return {"mensaje": "¡Plato identificado con éxito!", "plato": respuesta_bd.data[0]}
        
    except Exception as e:
        return {"error": f"Ocurrió un error en el servidor: {str(e)}"}

@app.get("/modelos")
def listar_modelos():
    try:
        modelos_permitidos = []
        for m in genai.list_models():
            if 'generateContent' in m.supported_generation_methods:
                modelos_permitidos.append(m.name)
        return {"modelos_que_puedes_usar": modelos_permitidos}
    except Exception as e:
        return {"error": str(e)}