# Práctica de Ansible

Proyecto académico para automatizar la configuración de cinco servidores Ubuntu en contenedores Docker usando Ansible por SSH.

## Requisitos

- Windows 10/11.
- Docker Desktop con integración WSL habilitada.
- WSL 2 con Ubuntu.

## 1. Preparar WSL y Ansible

Desde PowerShell como administrador:

```powershell
wsl --install
```

Reinicia Windows si lo solicita y completa la configuración inicial de Ubuntu.

Dentro de la terminal Ubuntu (WSL):

```bash
sudo apt update
sudo apt install -y ansible sshpass
```

Comprueba que Docker Desktop esté iniciado y que la integración con tu distribución Ubuntu esté habilitada en Settings > Resources > WSL Integration.

Comprueba desde WSL:

```bash
docker --version
docker compose version
ansible --version
```

## 2. Levantar los cinco servidores

Abre WSL en la carpeta del proyecto y ejecuta:

```bash
docker compose up -d --build
```

Verifica que estén activos:

```bash
docker compose ps
```

Los puertos publicados en el equipo anfitrión son:

| Servidor | Puerto SSH |
|---|---:|
| servidor1 | 2221 |
| servidor2 | 2222 |
| servidor3 | 2223 |
| servidor4 | 2224 |
| servidor5 | 2225 |

Cada contenedor escucha SSH en el puerto 22. Los puertos 2221–2225 permiten distinguir los cinco servidores desde WSL.

## 3. Probar la conexión con Ansible

Entra en la carpeta de Ansible:

```bash
cd ansible
```

Ejecuta la prueba de conectividad:

```bash
ansible servidores -m ping
```

Se debe obtener `pong` para cada servidor.

## 4. Ejecutar el playbook

```bash
ansible-playbook playbook.yml
```

El playbook realiza en los cinco servidores:

1. Actualiza la caché de APT.
2. Crea el usuario `itla`.
3. Crea el directorio `/app`.
4. Crea `/app/hola.txt`.
5. Instala `cowsay` y `htop`.

## 5. Verificar los resultados

Desde la carpeta `ansible`:

```bash
ansible servidores -a "id itla"
ansible servidores -a "ls -l /app/hola.txt"
ansible servidores -a "cat /app/hola.txt"
ansible servidores -a "which cowsay htop"
```

También puedes entrar en un contenedor:

```bash
docker exec -it ubuntu-servidor1 bash
```

Y comprobar:

```bash
id itla
cat /app/hola.txt
cowsay "Hola ITLA"
htop --version
```

## Detener los servidores

Desde la carpeta raíz:

```bash
docker compose down
```

Para volver a iniciarlos:

```bash
docker compose up -d
```

## Nota de seguridad

Las credenciales `ansible/ansible` y la desactivación de la comprobación de claves SSH se utilizan únicamente para esta práctica local. No reutilices esta configuración en servidores reales ni publiques credenciales reales en GitHub.
