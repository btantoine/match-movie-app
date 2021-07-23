process.env.DATABASE_URL = process.env.MONGO_URI || "<your database url>";
process.env.NODE_ENV = process.env.NODE_ENV || 'development';
process.env.PORT = process.env.PORT || 4000;
process.env.PORTSOCKETIO = process.env.PORTSOCKETIO || 8000;
