#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Feed Image Data From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Data" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers image data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Feed From Cache Use Case

@@ -91,6 +114,28 @@ Given the customer doesn't have connectivity
#### Empty cache course (sad path): 
1. System delivers no feed images.

---

### Load Feed Image Data From Cache Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Data" command with above data.
2. System retrieves data from the cache.
3. System delivers cached image data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers no image data.

---

### Validate Feed Cache Use Case

@@ -105,6 +150,7 @@ Given the customer doesn't have connectivity
#### Expired cache course (sad path): 
1. System deletes cache.

---

### Cache Feed Use Case

@@ -125,6 +171,7 @@ Given the customer doesn't have connectivity
#### Saving error course (sad path):
1. System delivers error.

---

## Flowchart
