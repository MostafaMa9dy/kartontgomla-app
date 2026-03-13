## v4.3.2 6-Dec-2025
  [Update]  Security - App Builder REST API Authentication
  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-cirilla-v4-3-2/

## v4.3.0 29-Nov-2025
  [Feat] Upload Avatar
  [Update] Flutter SDK 3.38.x
  [Update] WC Order Cancel
  [Update] Free shipping zone
  [Update] Merge Cart
  [Fixed] Error when deleting individual items in the notification list
  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-cirilla-v4-3-0/

## v4.2.9 29-Otc-2025
  [Feat] Gokiwik gateway
  [Feat] Free shipping banner
  [Feat] Show out-of-stock in product detail
  [Feat] Display attribute images in the product detail slideshow
  [Support] Flutter SDK 3.35.x
  [Support] 16 KB memory page sizes for Android device
  [Support] avif image
  [Fixed] Remove Firebase Dynamic Links and replace them with Appsflyer
  [Fixed] The issue is that when selecting a country, all the fields under “Shipping and Billing” are hidden
  [Fixed] Pricing info display
  [Fixed] Product description images loads on second try
  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-cirilla-v4-2-9/

## v4.2.8 8-Jul-2025
  [Feat] Phonepe gateway
  [Update] Android 15 (API level 35) 
  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-cirilla-v4-2-8/

## v4.2.7 18-Jun-2025
  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-cirilla-v4-2-7/

## v4.2.6 19-May-2025
- [Integrations] Coupon Referral Program for WooCommerce
  
  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-cirilla-v4-2-6/

## v4.2.5 10-May-2025
- [Integrations] Coupon Referral Program for WooCommerce
  
  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-cirilla-v4-2-5/

## v4.2.4 3-May-2025
- [Feat] WooCommerce Order Again
- [Update] Hyperpay Gateway
- [Update] Myfatoorah Gateway
- [Update] Paystack Gateway
  
  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-cirilla-v4-2-4/

## v4.2.3 26-Apr-2025
- [Feat] Support for Flutter SDK 3.29.x
- [Update] Add background color on slide Product
- [Update] Add background color on Product Category
- [Fixed] Cart not showing due to server caching
- [Fixed] Error showing no data when opening the shipping Address screen
  
  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-cirilla-v4-2-3/

## v4.1.6 27-Dec-2024
- [Feat] Support for Flutter SDK 3.27.x
- [Integrations] WooCommerce Points and Rewards plugin
- [Integrations] Stripe Klarna payment gateway
- [Update] Stripe payment gateway
- [Update] Paypal payment gateway
- [Fixed] Send notification sound with ios using Firebase ( services account )
- [Fixed] Deep linking issue when opening app
- [Fixed] Field Layout custom checkout payment hidden when setting Checkout Modes of General is Multi-Steps in App builder
- [Fixed] Error focus inputs of Checkout page when active Enable address book in Profile of edit template App builder

  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-4-1-6/

## v4.1.5 15-Nov-2024
- [Feat] One page checkout
- [Support] iPhone and iPad Apps on Apple Silicon Macs
- [Fixed] Can't submit in contact form
- [Fixed] Can't logout when getting FCM token error
- [Fixed] Adaptive layout not working properly on ipad 13 inch
- [Fixed] Bug where range price will be hidden in Refine when Clear all in Product List

  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-4-1-5/

## v4.1.4 30-Oct-2024
- [Feat] Support for Java JDK 21 in Android Studio Ladybug
- [Feat] Migrated: Intenet connection notification functionality moved to the packages
- [Feat] Caching
- [Improve] Shimmer for product type variable on product detail screen
- [Improve] Loading slots after click to day
- [Improve] Refactor code of the vendor review feature
- [Fixed] Google pay on Android
- [Fixed] Cart fee data type error

  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-4-1-4/

## v4.1.3 18-Oct-2024
- [Feat] Vendor Review
- [Feat] Captcha for Forgot Password
- [Feat] Migrate Captcha Feature on App builder
- [Integrations] Migrate TranslatePress Plugin Integration to App builder
- [Update] Analyze Dart Code
- [Fixed] Can’t add to cart using TranslatePress Plugin
- [Fixed] iframe fullscreen for youtube video is not working
- [Fixed] Null data error when using the 'Sticky Banner' and opening the app for the first time

  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-4-1-3/

## v4.1.2 7-Oct-2024
  - [Update] Login with Facebook (Support login Limited Token with OIDC Token Validation and flutter_facebook_auth: 7.1.1)
  - [Update] “Max OTP Attempts,” “OTP Expiration Time,” and “OTP Verification Block Duration” for managing OTP limits and blocking times in the forgot password feature.
  - [Update] [App builder] Replaced PUT and DELETE methods with POST to improve compatibility with servers that do not support PUT and DELETE requests.
  - [Improvement] Added a loading overlay during the checkout process to prevent users from navigating back or clicking the checkout button multiple times, ensuring a smoother and more secure checkout experience.
  - [Fixed] Header in sidebar don't update data after login successful
  - [Fixed] Loading shimmer product in product list

  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-4-1-2/

## v4.1.1 30-Sep-2024
- [Integrations] YITH WooCommerce Brands Add-On

- [Improvement] Filter price_html in product

- [Fixed] Validate the data of the additional button cart
- [Fixed] Customize in tab in Menu bottom

- [Upgrade-Package] firebase_core: ^2.4.1 => 3.5.0
- [Upgrade-Package] firebase_auth: ^4.2.5 => 5.3.0
- [Upgrade-Package] firebase_messaging: ^14.9.4 => 15.1.2
- [Upgrade-Package] firebase_messaging_web: ^3.8.7 => 3.9.1
- [Upgrade-Package] firebase_analytics: ^10.1.0 => 11.3.2
- [Upgrade-Package] firebase_database: ^10.0.9 => 11.1.3
- [Upgrade-Package] firebase_dynamic_links: ^5.0.11 => 6.0.7
- [Upgrade-Package] sign_in_with_apple: ^4.0.0 => 6.1.2
- [Upgrade-Package] flutter_facebook_auth: ^4.0.1 => 7.1.1

- [Breaking-Change] Change share: ^2.0.4 package to share_plus: ^10.0.2 package

  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-4-1-1/

## v4.1.0 11-Sep-2024

- [Feat] Support Flutter 3.24.x
- [Feat] App Builder v5
- [Feat] Resources in Bookings
- [Feat] Select range by start date and end date in bookings
- [Feat] Text dynamic content on button
- [Feat] Enable/Disable geo search in product widgets
- [Feat] Deeplink: Open tab

- [Integrations] Smart coupon
- [Integrations] WPML plugin
- [Integrations] Paytm payment gateway

- [Improvement] Post detail Icon Visibility Improvement
- [Improvement] Alert when disable location services

- [Update] flutter_html in flutter_yith_track_order package
- [Update] flutter_html in flutter_yith_badge package
- [Update] Zoom webview checkout
- [Update] Use BitmapDescriptor.asset method instead of BitmapDescriptor.fromAssetImage method in Vendor List screen
- [Update] Deeplink: Open link directly to tabs on App
- [Update] Show cart fees
- [Update] Razorpay Payment Gateway
- [Update] PayTabs Gateway
- [Update] API chat GPT
- [Update] Disable geo location query products widget

- [Fixed] Error when calling the Cart API multiple times
- [Fixed] Multi language
- [Fixed] Login screen goes blank when setting layout: Image header top or Image header corner
- [Fixed] Images/media extend beyond the side of the screen in product description of product detail screen
- [Fixed] Error convert data
- [Fixed] Unescape text in profile screen
- [Fixed] Set key for custom tabs to rerender widgets
- [Fixed] Sync the items in the cart with the website after removing a product on the website
- [Fixed] Api checkout add header Nonce
- [Fixed] Cho set default sort product list screen by date
- [Fixed] Error data type of template data in vendor list widget
- [Fixed] Image of flutter html overflow in cirilla_html
- [Fixed] Guest checkout webview

  And some minor bugs fixed and improvements
  Detail: https://appcheap.io/changelogs-11-sep-2024/

## v3.9.0 27-Mar-2024
- [Feat] Support Flutter 3.19.x
- [Feat] Text to Speech AI
- [Feat] YITH WooCommerce Order & Shipment Tracking
- [Feat] Intercom Chat
- [Feat] YITH WooCommerce Badge Management
- [Feat] Loading after searching by barcode and QR code
- [Feat] Copy order info
- [Feat] Random Product
- [Feat] Register Actions
- [Feat] Register order actions
- [Feat] Register custom widgets
- [Feat] Register custom screens
- [Improvement] Changing from WillPopScope to PopScope
- [Improvement] Bottom bar code
- [Improvement] Get list coupon smart will show empty
- [Improvement] Scale position values
- [Improvement] Add context to product interaction
- [Improvement] Get title page product list when navigate by action
- [Fixed] Translate “No internet connection”
- [Fixed] Currency code for MyFatoorah Payment Gateway
- [Fixed] Checkout webview for Cashfree Payment Gateway

##  v3.8.1
- [Feat] Support Stripe Native form checkout
- [Feat] Reset Password by send OTP to Email
- [Feat] HTTP Request Action
- [Feat] Dynamic Form (HTML and Contact Form 7 input)
- [Feat] Support Translatepress multi language plugin
- [Feat] Query any data in product detail
- [Feat] Identify App Orders
- [Upgrade] Flutter 3.16.x
And some minor bugs fixed and improvements
Detail: https://appcheap.io/changelogs-27-jan-2024/

## v3.8.0 04-Nov-2023
- [Add-ons] Cirilla – Express checkout add on with Apple and Google pay
- [Plugin] SpeedyPay payment gateway plugin
- [Feat] Pass custom data to build-in screen from custom screen.
- [Feat] Notification sound
- [Add-ons] Iyzico Payment Gateway
- [Feat] Sticky Banner
- [Feat] Profile screen – Adjust button icons in top right screen
- [Feat] Product Item – Show/Hide progress sale in template Curve
- [Integration] Additional Section in Checkout Page by Checkout Field Manager Plugin
- [Integration] Conditional fields in Checkout Page by Checkout Field Manager Plugin
- [Improvement] Config length of passcode in screen mobile verification
- [Improvement] Open deeplink in webview
- [Fix] Escape add-ons data in cart item
- [Fix] Step quantity of product variable
- [Fix] Show twitter’s the news and news story published with a video inside the url in post detail screen
- [Fix] Get url image and text when setting in App Builder
- [Fix] Conditional display style in post screen
And some minor bugs fixed and improvements
Detail: https://appcheap.io/changelogs-03-nov-2023/
## v3.7.9 01-Sep-2023
- [Improved] Performance open the app
- [Upgrade] Flutter 3.13.2
- [Upgrade] Payment gateway – Tabby (Add-on package)
- [Added] Shipping Method Layout Direction
- [Added]  Buddypress – Filter group, member
- [Integration] Better messages
- [Feat] Overwrite custom tab by build in navigation screen
- [Feat] OneSignal Push Notifications
- [Fixed] Error when list category empty
- [Fixed] Displays the coupon price without tax in cart screen
- [Fixed] Go to notification detail error
And some minor bugs fixed and improvements
Detail: https://appcheap.io/changelogs-1-sep-2023/

## v3.7.8 09-Aug-2023
- [Feat] Layout profile
- [Feat] Integrations – bbPress plugin
- [Feat] Push notification – buddypress
- [Feat] Integrations – B2BKing Pro
- [Feat] Google Fonts Update
- [Improved] flutter_webview_plus package
- [Improved] flutter_shopping_video visibility_detector version
- [Improved] RTL product detail, widgets, product blocks
- [Improved] build:gradle:7.3.0 & device_info_plus: ^9.0.3
- [Fixed] Convert data wishlist
- [Fixed] Value in widget inspired menu bottom
- [Fixed] Top of floating layout creative can’t clickable
- [Fixed] Variable product stock inherit from parent
- [Fixed] Token init after user status changed
- [Fixed] Cart key pass to wallet gateway wrong after login
Detail: https://appcheap.io/changelogs-9-aug-2023/

## v3.7.7 24-July-2023
- [Feat] Query Data Selector
- [Feat] Dynamic product list layout
- [Feat] Buddypress widgets
- [Feat] Sync cart
- [Feat] Geolocation, upload files Flutter webview v4.x
Detail: https://appcheap.io/changelogs-24-july-2023/

## v3.7.6 11-July-2023
- [Fixed] Data fields shipping/billing address empty
- [Fixed] Order received screen show login form
- [Fixed] Parse gateway data in checkout flow
- [Support] Filter product list with brand
- [Support] Geolocation, upload files Flutter webview v4.x
- [Added] Wallet checkout in custom checkout flow

## v3.7.5 06-July-2023
- [Support] Add post list to bottom navigation
- [Support] Disable image in post item
- [Support] Dynamic post list layout
- [Fix] Convert data attributes
- [Fix] Quantity in product detail
- [Improve] Full screen video on webview
- [Add] Empty download screen
- Some minor bugs fixed and improvements

## v3.7.4 15-Jun-2023
- [Support] Smart coupon plugin
- [Support] Filter product list by list categories (Ex: category=ID1,ID2,ID3)
- [Add] Show vertical payment method (Checkout flow)
- [Chore] Show buy now when select variable

## v3.7.3 12-Jun-2023
- [Support] Merge local cart and user's cart after user successfully login
- [Improve] Validate checkout form before next step (checkout flow)
- [Upgrade] cirilla_ads dependencies
- [Fix] Language in product tab widget
- [Fix] Null block posts blocks
- [Chore] Translate shopping video widget

## v3.7.2 09-Jun-2023
- [Support] Ajax search pro plugin
- [Fix] Terawallet is not deducting from available credit
- [Fix] Pressing the button add to cart automatically zoom in
- [Update] Load more and screen empty in brand screen
- [Update] “Razorpay native gateway” compatible with Flutter SDK 3.10.x

## v3.7.1 07-Jun-2023
- [Support] Open deeplink in app with format `domain.com/product/slug-name` or `domain.com/post/slug-name`
- [Support] Show/Hide bottom navigation bar
- [Improve] Show filename upload in cart and product detail screen
- [Fix] The app freeze after login in checkout
- [Improve] Hide out of stock variations
- Some minor bugs fixed and improvements
[https://appcheap.io/changelog-7-june-2023/](https://appcheap.io/changelog-7-june-2023/)

## v3.7.0 05-Jun-2023

- [Upgrade] Latest Flutter 3.10.3
- [Upgrade] Gradlew 7.5, build tools 7.2.0 and kotlin 1.7.10
- [Add] Share dynamic for product, post
- [Support] Upload file in product addons plugin
- [Fix] Duplicate post list screen
- [Fix] Count Type default value in bottom navigation
- [Modify] CFBundleName cirilla => Cirilla Store

[https://appcheap.io/changelog-5-june-2023/](https://appcheap.io/changelog-5-june-2023/)

## v3.6.0 17-April-2023

[Changelogs](https://appcheap.io/changelog-17-april-2023/)

## v3.5.0 07-April-2023

[Changelogs](https://appcheap.io/changelog-07-april-2023/)

## v3.4.0 08-Feb-2023

[Changelogs](https://appcheap.io/changelog-08-feb-2023/)

## v3.2.1 29-Dec-2022

[Changelogs](https://appcheap.io/changelog-29-dec-2022/)

## v3.2.0 16-Dec-2022

[Changelogs](https://appcheap.io/changelog-16-dec-2022/)

## v3.2.0 22-Sept-2022

[Changelogs](https://appcheap.io/changelog-22-sept-2022/)

## v3.1.1 17-Aug-2022

[Changelogs](https://appcheap.io/changelog-17-aug-2022/)

## v3.1.0 15-Aug-2022

[Changelogs](https://appcheap.io/changelog-15-aug-2022/)
