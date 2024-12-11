### Steps to Run the App

1. **You Must Have:**
   - **Xcode**
   - **iOS Device/Simulator**

2. **Clone the Repository:**
   ```bash
   git clone https://github.com/Condo97/FetchRecipesApp.git
   ```
   
3. **Open the Project:**
   - Navigate to the cloned directory.
   - Open `FetchRecipesApp.xcodeproj` with Xcode.

4. **Build the Project:**
   - Select the desired simulator or connect your iOS device.
   - Press `Cmd + R` or click the **Run** button in Xcode to build and run the app.

5. **Using the App:**
   - **Import Recipes:** Enter or use a preloaded valid recipe JSON URL and tap "Add Recipes" to fetch and display recipes.
   - **View Details:** Tap on any recipe to view detailed information, including images, source URLs, and UUIDs.
   - **Delete Recipes:** Use the trash button to delete all stored recipes.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

**Storage**
The app uses CoreData to store recipes and the user's documents directory to store image data. This leads to a super fast UI that persists between launches.

**Networking**
Recipes are loaded using concurrency and specifically a task group to speed up the download and storage. Each recipe and its images are downloaded in an independant task so loading is nearly instantaneous. 

**UI**
States are strategically used to activate and disable buttons and update UI elements for an intuitive expereience. There are a few hidden enhancements including context menus in the detail view to easily copy data.

**Time Efficiency**
The fetch request modifier is used for efficient recipe fetching on the UI side. Images are cached to disk on save for fast loading times and to reduce network load. Native SwiftUI structure is respected to preserve system load optimizations. Recipes are downloaded concurrently to update and save quickly. On download recipes are updated by UUID and the image cache is only updated if the new and old URLs are different.

**Space and Network Efficiency**
Images are cached in the device's storage to prevent unnecessary network load. Each recipe can be updated with new JSON values including new image URLs. If new different image URLs are noticed on the update then are images re-cached. When updating cached images with different images and deleting recipe records, it removes the stale images from the disk to prevent bloat. 

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I had a little fun with it, so I spent approximately seven hours on this project. My time was allocated as follows:
- **30m** - Understand the requirements
- **30m** - Brainstorm solutions and sketch out UI
- **4h** - Implementation
  - **30m** - Web handler
  - **30m** - CoreData model and helper functions
  - **30m** - Image cache and helper functions
  - **2hr** - UI, View creation
  - **30m** - Error handling including invalid URL and missing JSON alerts
- **2h** - Testing & bug fixing
  - **30m** - Write tests
  - **45m** - Fix issues
  - **15m** - Rewrite tests
  - **30m** - Final fix

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

I tried to make the app as complete as possible--storing objects by UUID with the ability to dynamically update them, displaying all recipe values in detail view, persistence between launches without redownload--but with any implementation there are trade-offs. One major trade off I made was using a ForEach instead of a List to display recipes. This prevents the swipe to delete modifier from being implemented, so recipes are deleted with a context menu. The reason for this trade off was a style choice, because I wanted the rows to look like cards and if they were list elements the swipe to delete animation would move the background and foreground together. Instead, presenting the deletion option using context menu with this style is more appropriate. 

### Weakest Part of the Project: What do you think is the weakest part of your project?

I actually think this is a pretty strong project.. One of my recent projects, ChefApp, is a recipes app that takes users ingredients, sends them to GPT with a prompt, and parses the response in a formatted and searchable manner. ChefApp app even pulls a relevant image from Bing and caches in a similar manner as this challenge, though it uses AppGroups for shared storage. This challenge channeled my enjoyment and experience of working on ChefApp and I believe it ended up pretty solid. The weakest part of the project in my opinion is the tests. They tests are not full coverage but they do test the core requriements, including networking and persistence. 

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

This was a fun project. I had just finished a recipe app, [ChefApp](https://apps.apple.com/us/app/chefapp-ai-recipe-creator/id6450523267), which shares procedures. To preserve the integrity of the challenge I did not copy and paste from my app. As a result, coding this helped reinforce my knowledge and pushed me to learn new strategies that I will be implementing in my own app.
