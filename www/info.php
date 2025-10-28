<?php
$host = "192.168.56.11"; // IP de la máquina 'db'
$port = "5432";
$dbname = "ejemplo";
$user = "vagrant";
$password = "vagrant";

$conn = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password");

if (!$conn) {
    die("<h2>Error al conectar con la base de datos.</h2>");
}

echo "<h2>Conexión exitosa con la base de datos PostgreSQL </h2>";

$result = pg_query($conn, "SELECT * FROM personas;");
if (!$result) {
    die("<p>Error al ejecutar la consulta.</p>");
}

echo "<table border='1' cellpadding='8' cellspacing='0'>";
echo "<tr><th>ID</th><th>Nombre</th></tr>";

while ($row = pg_fetch_assoc($result)) {
    echo "<tr><td>{$row['id']}</td><td>{$row['nombre']}</td></tr>";
}

echo "</table>";

pg_close($conn);
?>
