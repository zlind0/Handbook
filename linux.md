# D

# L
## Latex-texlive

### overleaf docker

```
wget https://raw.githubusercontent.com/overleaf/overleaf/master/docker-compose.yml
docker compose up
```

### change CTAN mirror

```
tlmgr option repository http://mirrors.aliyun.com/CTAN/systems/texlive/tlnet/ 
```

### upgrade texlive distribution

```
docker exec -it sharelatex bash 
cd /usr/local/texlive 
cp -a 2020 2021
wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh
sh update-tlmgr-latest.sh -- --upgrade 
tlmgr update --self --all 
luaotfload-tool -fu 
```
