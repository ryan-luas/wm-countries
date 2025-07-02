# wm-countries

### Requirements:
1.) Fetch a list of countries from:
`https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json`

2.) Display the countries in a `UITableView` ordered by the position they appear in the api response. Each row should display `name`, `region`, `code` and `capital` in this format.

3.) Use `UISearchController` to enable filtering by `name` or `capital` as the user types each character of their search.

4.) Implementation should be robust (i.e., handle errors and edge cases), support dynamic type, support iPhone and iPad, and support device rotation.


### 60min Feature List:
- [x] iPhone & iPad Support 📲
- [x] Search Country List by Name or Capital 🌍
- [x] Portrait & Landscape Device Orientations 📱
- [x] Custom Error Handling ⚠️
- [x] Dynamic Type Support ⌨️

















*__idiosyncrasies:__ I beleive this is just a side effect of having iOS 26 and macOS Tahoe on my machine, however when running on iOS 18.5 simulator, there is an odd bug that points to a "Loudness Manager" from the SDK. (It only occurs when typing in the search controller). Run on iOS Simulator 18.4 and it goes away. 👍🏼*