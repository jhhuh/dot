{ python3, jq }:

let

  pyEnv = python3.withPackages (pp: with pp; [ requests beautifulsoup4 ]);

  script = ''
    import json

    import requests
    from bs4 import BeautifulSoup

    url = "https://hackage.haskell.org/packages/top"


    if __name__ == "__main__":
      resp = requests.get(url)
      soup = BeautifulSoup(resp.content)
      rows = soup.select("div#content tr")[1:]
      result = [ row.a.text for row in rows ]

      res = {}
      res["headers"] = dict(resp.headers)
      res["result"] = result

      print(json.dumps(res))
    '';

in

''
  ${pyEnv}/bin/python3 <<EOPYTHON | ${jq}/bin/jq | tee  ./hackage-top-packages.json
  ${script}
  EOPYTHON

''
