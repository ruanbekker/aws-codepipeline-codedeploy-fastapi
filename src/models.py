from pydantic import BaseModel
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "Awesome API"
    admin_email: str = "admin@admin.local"
    items_per_user: int = 50
        
class Student(BaseModel):
    userid: str
    email: str

