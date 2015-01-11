## New Job

Creates a new job after taking in company
authentication by using pickup and destination
GeoPoints and address strings, and continuously
searches in the background for the first 
available worker in closest proximity to this
new jobs pickup site.

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

**Returns**

```
{
  success: Boolean
}
```

## Cancel Job

Sets the specified jobs status to Cancelled .

```
POST /api/:job/cancel
```

**Parameters**

```
{ 
  // Company Indentification

  key: String
  secret: String
 
  // API Parameters
  job: String
}
```

**Returns**
```
{
  success: Boolean
}
```

## Job Status

Returns the value for the specified jobs status.

```
GET /api/:job/status
```

**Parameters**

```
{  
  // Company Indentification

  key: String
  secret: String
  
  // API Parameters
  job: String  
}
```

**Returns**

'''
{
  status: Float
  success: Boolean

}
'''
