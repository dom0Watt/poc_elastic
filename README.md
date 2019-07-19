Dans le docker-compose.yml, dans le service kafka, mettre a jour ADVERTISED_HOST_NAME avec l'ip de votre machine (ceci est nécessaire à cause de docker desktop sous windows).

Demarrer tout le projet
```
docker-compose up
```

configurer le connector postgres dans kafka connect
```
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-postgres.json
```

Ouvrir kibana dans un browser: localhost:5601 , username: admin et mot de passe: admin

```
PUT racing
{
  "mappings": {
    "properties": {
       "descriptif": { "type": "text" },
       "etude": { "type": "text" },
       "canalentree": { "type": "text" },
       "libelle": { "type": "text" },
       "id": { "type": "keyword" },
       "realisation": { "type": "text" },
       "centre": { "type": "text" },
       "finalite": { "type": "text" }
     }
  },
  "settings": {
    "analysis": {
      "filter": {
        "french_elision": {
          "type":         "elision",
          "articles_case": true,
          "articles": [
            "l", "m", "t", "qu", "n", "s",
            "j", "d", "c", "jusqu", "quoiqu",
            "lorsqu", "puisqu"
          ]
        },
        "french_stop": {
          "type":       "stop",
          "stopwords":  "_french_"
        },
        "french_keywords": {
          "type":       "keyword_marker",
          "keywords":   ["Exemple"]
        },
        "french_stemmer": {
          "type":       "stemmer",
          "language":   "light_french"
        }
      },
      "analyzer": {
        "rebuilt_french": {
          "tokenizer":  "standard",
          "filter": [
            "french_elision",
            "lowercase",
            "french_stop",
            "french_keywords",
            "french_stemmer"
          ]
        }
      }
    }
  }
}
```
Pour voir les documents dans elastic, aller dans les outils de dev et jouer la requete:
```
GET racing/_search
```

Pour tester, on peut demarrer un client postgres, afin de créer /updater / effacer des affaires.
La table affaires a été créee préalablement (voir postgres/docker-entrypoint-initdb.d/racing.sql)
```
docker-compose exec postgres env PGOPTIONS="--search_path=racing" bash -c 'psql -U $POSTGRES_USER postgres'
```

puis inserer des records:
```
\i /data/affaires.sql
```
