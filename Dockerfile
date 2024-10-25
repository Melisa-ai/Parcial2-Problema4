# A través del comando 'from' se hace referencia al uso de la imagen oficial de Node.js en la versión 14
FROM node:14

# La sentencia 'workdir' genera un directorio de trabajo, donde se va a almacenar la aplicación 
WORKDIR /usr/src/app

# Copia el archivo package.json y package-lock.json al directorio de trabajo en el contenedor.
# Estos archivos contienen la lista de dependencias necesarias para el proyecto Node.js.
COPY package*.json ./

# El comando 'RUN npm install' para descargar y ejecutar todas las dependencias de la aplicación dentro del contenedor.
RUN npm install

# Con copy se copia el código de la aplicación incluyendo el directorio local y de trabajo dentro del contenedor
COPY . .

# Lo siguiente actualiza la lista de todos los paquetes y también se instala MySQL dentro del contenedor para que pueda trabajar con base de datos.
# Además, 'apt-get clean' se utiliza para que el sistema no acumule archivos innecesarios, y de esa manera no esté saturado de espacio.
RUN apt-get update && \
    apt-get install -y mysql-server && \
    apt-get clean

# Exponer los puertos 3000 y 3306, donde el puerto 3306 se usa para permitir conexiones hacia la 
#base de datos, en este caso MySQL y el puerto 3000 será donde se va a ejecutar la app web de Node.js
EXPOSE 3000 3306

# Con la siguiente sentencia, si se tiene un archivo sql para inicializar la base de datos con algunos datos, se copia una ruta especial,
# en este caso es /docker-entrypoint-initdb.d/. De esta manera, cuando el contenedor se inicie, la base de datos se ejecutará automáticamente.
COPY ./init.sql /docker-entrypoint-initdb.d/

# Define el comando que se ejecutará al iniciar el contenedor.
# Aquí, "npm start" inicia el servidor Node.js, mientras que MySQL se inicia de forma automática en segundo plano.
CMD ["npm", "start"]
