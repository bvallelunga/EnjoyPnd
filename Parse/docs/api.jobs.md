# Job

## New Job  -  module.export.jobs

Creates a new job and searches for the first
available user by nearest location to the job
pickup site.

```
POST /api/job/
```

**Parameters**

```
{
  
  // Company Indentification

  key: String
  secret: String
  
  // API Parameters

  name: String
  pickup: {
    address: String,
    lat: Float,
    lng: Float
  }
  destination: {
    address: String,
    lat: Float,
    lng: Float
  }
  
}

```

## Cancel Job

Sets the specified jobs status to Cancelled .

```
POST /api/job/
```

**Parameters**

```
{
  
  // API Parameters
  job: String
  
}
```

## Job Status

Returns the value for the specified jobs status.

```
GET /api/job/
```

**Parameters**

```
{
  
  // API Parameters
  job: String
  
}
```
