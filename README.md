# List People
Imagine we are creating a simple, single screen app that lists people.

	- Every person that is listed has an `id` and a `fullName`
	- There are lots of people to list and only a small subset of them can be retrieved from our `DataSource` at once. So we need a "pagination" mechanism.
	- There should be a "Refresh Control" for refreshing the list.
	- Proper error handling and a retry implemention is required.
	- When there is no one for listing, a proper message should be displayed. Also, in this case, we need to implement a functionality to refresh the list.
	- Listing should be unique by person `id`. Duplicate items are not allowed. (People who have same `fullName`s but different 'id's are allowed.)

-----

1) You are provided pre-implemented classes like `DataSource`, `Person`, `FetchResponse` and `FetchError`. Import "DataSource.swift" in your project and review it.
2) You can use UITableView (or UICollectionView) in order to display data.
3) In order to fetch first set of people, use `DataSource`s `fetch` method by passing nil into its `next` parameter and a completion handler.
4) "Completion Handler" has 2 parameters in its signature. A response or an error instance is passed when the operation finishes. They can't be both nil or hold non-nil references at a time.
5) When success, `FetchResponse` instance is passed into completion handler. This instance has people array and a `next` identifier which can be used for pagination.
6) Pass successful response's `next` identifier into `fetch` method in order to get next "pages".

-----

Tips:
	- Retrying aggressively is bad for our "backend service"
	- No 3rd party dependency is required.
	- You can change `constants` in `DataSource` class for testing purposes.
	- No action is required for item selection.
	- Some screenshots are provided for you.
