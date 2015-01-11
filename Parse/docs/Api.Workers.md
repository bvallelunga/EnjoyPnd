## Workers
Get worker information for a specific company

```
GET /api/workers/
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
```

## Worker Pending

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
  worker: String 
  
}
```

## Worker Info

Returns the username, company name, email, name, and status
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
  worker: String
  
}
```

## Approve or Decline Pending Worker

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
  worker: String
  
}
```
