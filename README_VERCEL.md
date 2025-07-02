# TRATO - Despliegue en Vercel

## 📱 Aplicación TRATO
Red Social de Negocios desarrollada en Flutter

## 🚀 Despliegue en Vercel

### Opción 1: Despliegue desde GitHub (Recomendado)

1. **Sube el proyecto a GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit - TRATO App"
   git branch -M main
   git remote add origin https://github.com/tu-usuario/trato-app.git
   git push -u origin main
   ```

2. **Conecta con Vercel:**
   - Ve a [vercel.com](https://vercel.com)
   - Inicia sesión con GitHub
   - Haz clic en "New Project"
   - Selecciona tu repositorio `trato-app`
   - Vercel detectará automáticamente la configuración

3. **Configuración automática:**
   - Vercel usará el archivo `vercel.json` incluido
   - Los archivos se servirán desde `build/web/`
   - El dominio será: `https://trato-app-tu-usuario.vercel.app`

### Opción 2: Despliegue directo con Vercel CLI

1. **Instala Vercel CLI:**
   ```bash
   npm i -g vercel
   ```

2. **Inicia sesión:**
   ```bash
   vercel login
   ```

3. **Despliega desde la carpeta del proyecto:**
   ```bash
   vercel --prod
   ```

### Opción 3: Arrastrar y soltar

1. Ve a [vercel.com/new](https://vercel.com/new)
2. Arrastra la carpeta `build/web` completa
3. Vercel creará el despliegue automáticamente

## 🔧 Configuración incluida

### vercel.json
```json
{
  "version": 2,
  "builds": [
    {
      "src": "build/web/**",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/build/web/$1"
    },
    {
      "src": "/",
      "dest": "/build/web/index.html"
    }
  ],
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/build/web/index.html"
    }
  ]
}
```

## 🌐 Configuración de dominio personalizado

1. En el dashboard de Vercel, ve a tu proyecto
2. Haz clic en "Settings" > "Domains"
3. Agrega tu dominio personalizado
4. Configura los DNS según las instrucciones

## 🔐 Variables de entorno (si es necesario)

Si necesitas configurar variables de entorno:

1. Ve a "Settings" > "Environment Variables"
2. Agrega las variables necesarias:
   - `FIREBASE_API_KEY`
   - `FIREBASE_PROJECT_ID`
   - etc.

## 📱 Funcionalidades incluidas

✅ **Autenticación:**
- Google Sign-In (configurado)
- Facebook Sign-In (preparado)
- Email/Password

✅ **Firebase Integration:**
- Authentication
- Firestore Database
- Storage

✅ **Responsive Design:**
- Optimizado para móvil y desktop
- PWA ready

## 🔄 Actualizaciones

Para actualizar la aplicación:

1. **Recompila:**
   ```bash
   flutter build web --release
   ```

2. **Si usas GitHub:**
   ```bash
   git add .
   git commit -m "Update app"
   git push
   ```
   Vercel se actualizará automáticamente.

3. **Si usas CLI:**
   ```bash
   vercel --prod
   ```

## 📞 Soporte

- **Documentación Vercel:** [vercel.com/docs](https://vercel.com/docs)
- **Flutter Web:** [flutter.dev/web](https://flutter.dev/web)

---

**¡Tu aplicación TRATO está lista para ser compartida con el mundo! 🚀**
