# Repositorio APT de JKLabs

## Cómo consumir este repositorio APT

1. Importar clave pública:
```bash
curl -fsSL https://jcprieto.github.io/jklabs-apt-repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/jklabs-archive-keyring.gpg
```

2. Crear fuente APT:
```bash
echo "deb [signed-by=/usr/share/keyrings/jklabs-archive-keyring.gpg] https://jcprieto.github.io/jklabs-apt-repo stable main" | sudo tee /etc/apt/sources.list.d/jklabs.list
```

3. Actualizar e instalar:
```bash
sudo apt update
sudo apt install <nombre-paquete>
```

## Paquetes publicados (rama `gh-pages`)

Listado de aplicaciones instalables verificado en `dists/stable/main/binary-amd64/Packages`:

<!-- PACKAGES-LIST:START -->
- `beyondsqlexecutor` (`1.1.9`)
- `loteriadenavidad` (`2.7.1`)
<!-- PACKAGES-LIST:END -->

Rutas útiles:
- Índice de paquetes: `https://jcprieto.github.io/jklabs-apt-repo/dists/stable/main/binary-amd64/Packages`
- Metadata de release: `https://jcprieto.github.io/jklabs-apt-repo/dists/stable/Release`
