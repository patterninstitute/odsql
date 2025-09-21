# Opendatasoft explore API v2.1 examples

## Successful Requests

### Basic query (no parameters)
```{r}
library(httr2)
base_url <- "https://public.opendatasoft.com/api/explore/v2.1" 
dataset <- "jcdecaux-bike-stations-data-rt"
endpoint <- paste0(base_url, "/catalog/datasets/", dataset, "/records")
request(endpoint) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records
Status: 200 OK
Content-Type: application/json
Body: In memory (3596 bytes)
```

---

### Basic query (`select=*`)
```{r}
request(endpoint) |> 
    req_url_query(
        select="*",
        limit=5) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?select=%2A&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (1862 bytes)
```

---

### Select and rename fields
```{r}
request(endpoint) |> 
    req_url_query(
        select="address as endereco",
        limit=5) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?select=address%20as%20endereco&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (319 bytes)
```

---

### Basic query (no filter, limit 5)
```{r}
request(endpoint) |> 
    req_url_query(limit=5) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (1862 bytes)
```

---

### Pagination: `offset 5, limit 5`
```{r}
request(endpoint) |> 
    req_url_query(
        limit=5,
        offset=5) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?limit=5&offset=5
Status: 200 OK
Content-Type: application/json
Body: In memory (1768 bytes)
```

---

### Sort ascending
```{r}
request(endpoint) |> 
    req_url_query(
        limit=5,
        sort="name") |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?limit=5&sort=name
Status: 200 OK
Content-Type: application/json
Body: In memory (1862 bytes)
```

---

### Sort descending
```{r}
request(endpoint) |> 
    req_url_query(
        limit=5,
        sort="-available_bikes") |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?limit=5&sort=-available_bikes
Status: 200 OK
Content-Type: application/json
Body: In memory (1862 bytes)
```

---

### Filter numeric: `available_bikes > 10`
```{r}
request(endpoint) |> 
    req_url_query(
        where="available_bikes>10",
        limit=5) |> 
    req_perform() 
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?where=available_bikes%3E10&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (1845 bytes)
```

---

### Filter text: `contract_name="dublin"`
```{r}
request(endpoint) |> 
    req_url_query(
        where="contract_name=\"dublin\"",
        limit=5) |> 
    req_perform() 
```

Result:

```
<httr2_response>
GET
https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?where=contract_name%3D%22dublin%22&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (1662 bytes)
```

---

### Filter with IN: `contract_name IN ("lillestrom", "amiens")`
```{r}
request(endpoint) |> 
    req_url_query(
        where="contract_name IN (\"lillestrom\", \"amiens\")",
        limit=5) |> 
    req_perform() 
```

Result:

```
<httr2_response>
GET
https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?where=contract_name%20IN%20%28%22lillestrom%22%2C%20%22amiens%22%29&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (1710 bytes)
```

---

### Filtering with LIKE
```{r}
request(endpoint) |> 
    req_url_query(
        select="address as endereco",
        where="address like \"%angle%\"",
        limit=5) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET
https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?select=address%20as%20endereco&where=address%20like%20%22%25angle%25%22&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (208 bytes)
```

---

### Filter boolean (`banking=true`)
This is not a boolean, because the dataset has the booleans as string 
```{r}
request(endpoint) |> 
    req_url_query(
        where="banking=\"true\"", #where="banking=true"
        limit=5) |> 
    req_perform() 
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?where=banking%3D%22true%22&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (33 bytes)
```

---

### Filter datetime (`last_update > "2025-06-01"`)
```{r}
request(endpoint) |> 
    req_url_query(
        where="last_update > \"2025-06-01\"", 
        limit=5) |> 
    req_perform() 
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?where=last_update%20%3E%20%222025-06-01%22&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (1862 bytes)
```

---

### Full text search (over all variables)
```{r}
request(endpoint) |> 
    req_url_query(
        where="\"PALETTE\"",
        limit=5) |> 
    req_perform() 
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?where=%22PALETTE%22&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (409 bytes)
```

---

### Aggregate (count by contract_name)
```{r}
request(endpoint) |> 
    req_url_query(
        select="contract_name, count(*) as qtd",
        group_by="contract_name",
        limit=5) |> 
    req_perform() 
```

Result:

```
<httr2_response>
GET
https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?select=contract_name%2C%20count%28%2A%29%20as%20qtd&group_by=contract_name&limit=5
Status: 200 OK
Content-Type: application/json
Body: In memory (256 bytes)
```

---

## Failing Requests

### Invalid dataset ID
```{r}
dataset0 <- "fake_dataset_id"
endpoint0 <- paste0(base_url, "/catalog/datasets/", dataset0, "/records")
ignore_it <- function(resp) FALSE

request(endpoint0) |> 
    req_error(is_error=ignore_it) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/fake_dataset_id/records
Status: 404 Not Found
Content-Type: application/json
Body: In memory (108 bytes)
```

---

### Unknown field in select
```{r}
request(endpoint) |> 
    req_url_query(select="field1") |> 
    req_error(is_error=ignore_it) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?select=field1
Status: 400 Bad Request
Content-Type: application/json
Body: In memory (140 bytes)
```

---

### Unknown field in where
```{r}
request(endpoint) |> 
    req_url_query(where="field1 > 1") |> 
    req_error(is_error=ignore_it) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?where=field1%20%3E%201
Status: 400 Bad Request
Content-Type: application/json
Body: In memory (139 bytes)
```

---

### Syntax error in filter
```{r}
request(endpoint) |> 
    req_url_query(where="available_bikes >") |> 
    req_error(is_error=ignore_it) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?where=available_bikes%20%3E
Status: 400 Bad Request
Content-Type: application/json
Body: In memory (180 bytes)
```

---

### Invalid value type in filter
```{r}
request(endpoint) |> 
    req_url_query(where="available_bikes=True") |> 
    req_error(is_error=ignore_it) |> 
    req_perform()
```

Result:

```
<httr2_response>
GET https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/jcdecaux-bike-stations-data-rt/records?where=available_bikes%3DTrue
Status: 400 Bad Request
Content-Type: application/json
Body: In memory (193 bytes)
```