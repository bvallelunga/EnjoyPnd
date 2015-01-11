# Worker

## Workers

description:
returns worker information for a specific company

```
GET /api/workers/
```

**Parameters**

{
  
  // Company Identification
  key: String
  secret: String
  
  // API Parameters
  company: String

}

## Worker Pending

description:
Adds workers of a company to be pending for a job.

```
GET /api/workers/pending
```

**Parameters**

```

{
  
  // Company Identification
  key: String
  secret: String
  
  // API Parameters
  company: String 
  
}

## Worker Info

description:
returns the username, company name, email, name, and status
that the worker is associated with.

```
GET /api/:worker/info
```

**Parameters**

```

{
  
  // Company Identification
  key: String
  secret: String
  
  // API Parameters
  id: String
  
}

## Worker Function

description:
Adds workers of a company to be pending for a job.

```
GET /api/workers/pending
```

**Parameters**

```

{
  
  // Company Indentification
  key: String
  secret: String
  
  // API Parameters
  company: String 
  
}

## Worker Function

description:
Updates the company's worker list with approved 
workers that had a pending employment status in the company.

```
POST /api/:worker/pending
```

**Parameters**

```

{
  
  // Company Indentification
  key: String
  secret: String
  
  // API Parameters
  company: String
  user: String
  
}
