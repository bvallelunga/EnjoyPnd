Our API enables **Uber for X** companies to utilize on demand
carriers for pickup & delivery! We have two APIs: [Jobs](https://github.com/bvallelunga/EnjoyPnD/blob/master/Parse/docs/Api.Jobs.md)
& [Workers](https://github.com/bvallelunga/EnjoyPnD/blob/master/Parse/docs/Api.Workers.md)


All APIs have the endpoint `http://enjoypnd.soojuicy.com` where authentication
is mandatory. Authentication is done through providing a `key` & `secert` found
on the [accounts page](http://enjoypnd.soojuicy.com/account).

```
{ 
  key: String
  secret: String
}
```
