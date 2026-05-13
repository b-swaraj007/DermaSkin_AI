I have a Flutter app called DermaScan AI 
built in FlutterFlow. I need you to connect 
all navigation and button actions across 
all screens. Here is the complete navigation 
map based on my actual UI screens:

Design System for reference:
Primary: Deep Teal (#0D5C63)
Accent Gold: (#C9A84C)
Background: Cream (#FAF8F5)
Font Display: Cormorant Garamond
Font Body: DM Sans

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 1 — SPLASH SCREEN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: splash_screen.dart

Actions:
- No buttons on this screen
- On screen load: start 2.5 second 
  timer using Future.delayed
- After 2.5 seconds: check if user 
  is already logged in
    IF logged in → navigate to 
      home_dashboard.dart
      (replace, no back stack)
    IF not logged in → navigate to 
      onboarding_carousel.dart
      (replace, no back stack)
- Use SharedPreferences to check 
  login state:
  key: 'is_logged_in' (bool)
  key: 'has_seen_onboarding' (bool)

Transition: fade transition, 
300ms duration

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 2 — ONBOARDING CAROUSEL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: onboarding_carousel.dart

Elements visible in image:
- 3 slide carousel (PageView)
- Dot pagination indicators
- "Get Started" teal pill button
- "Skip tour" text link

Button actions:

"Get Started" button:
  → Save 'has_seen_onboarding': true
    in SharedPreferences
  → Navigate to sign_up.dart
  → Transition: slide left, 300ms

"Skip tour" text link:
  → Same as Get Started button
  → Save 'has_seen_onboarding': true
  → Navigate to sign_up.dart
  → Transition: slide left, 300ms

Dot indicators:
  → Tapping dot 1: go to slide 1
  → Tapping dot 2: go to slide 2
  → Tapping dot 3: go to slide 3
  → Swiping left/right: 
    change slides naturally

On last slide (slide 3):
  → "Get Started" button 
    becomes active/highlighted

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 3 — SIGN UP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: sign_up.dart

Elements visible in image:
- Back arrow (top left)
- Full Name field
- Email Address field
- Password field
- Confirm Password field
- Terms & Privacy Policy links
- "Create My Account" teal button
- "Continue with Google" button
- "Continue with Apple" button
- "Already have account? Sign In" 
  link at bottom

Button actions:

Back arrow (top left):
  → Navigator.pop() 
  → Goes back to onboarding

"Create My Account" button:
  → Validate all fields:
      Full Name: not empty
      Email: valid email format
      Password: min 8 characters
      Confirm Password: matches
  → IF validation fails:
      Show inline error under 
      each failing field
      Red border on failed field
      Error text in coral (#E05C5C)
  → IF validation passes:
      Show loading spinner 
      on button
      Call Firebase Auth or 
      Flask backend signup API
      Save 'is_logged_in': true
      Save user name and email
      Navigate to 
      otp_verification.dart
      Transition: slide left

"Continue with Google" button:
  → Trigger Google Sign In flow
  → On success:
      Save 'is_logged_in': true
      Navigate to home_dashboard.dart
      Replace route, no back stack
  → On failure:
      Show snackbar error message

"Continue with Apple" button:
  → Trigger Apple Sign In flow
  → On success: same as Google
  → On failure: show snackbar

"Terms" underlined link:
  → Open terms_of_service.dart 
    OR launch URL in webview

"Privacy Policy" underlined link:
  → Open privacy_policy.dart 
    OR launch URL in webview

"Sign In" link at bottom:
  → Navigate to sign_in.dart
  → Transition: slide left

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 4 — SIGN IN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: sign_in.dart

Elements visible in image:
- DermaScan AI logo + tagline
- Email Address field
- Password field with show/hide eye
- "Forgot Password?" link
- "Sign In" teal button
- "Continue with Google" button
- "Continue with Apple" button
- "New here? Create an Account" link

Button actions:

"Sign In" button:
  → Validate fields:
      Email: not empty, valid format
      Password: not empty
  → IF fails: show field errors
  → IF passes:
      Show loading spinner
      Call auth API
      On success:
        Save 'is_logged_in': true
        Navigate to home_dashboard.dart
        Replace all routes 
        (no back to sign in)
      On failure:
        Show error snackbar:
        "Invalid email or password"

Password show/hide eye icon:
  → Toggle obscureText on 
    password field
  → Eye open = password visible
  → Eye closed = password hidden

"Forgot Password?" link:
  → Navigate to 
    forgot_password.dart
  → Transition: slide up 
    (bottom sheet style)

"Continue with Google":
  → Same as Sign Up Google flow
  → On success → home_dashboard

"Continue with Apple":
  → Same as Sign Up Apple flow
  → On success → home_dashboard

"Create an Account" link:
  → Navigate to sign_up.dart
  → Transition: slide right 
    (going back direction)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 5 — HOME DASHBOARD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: home_dashboard.dart

Elements visible in image:
- "Good morning, Vaishnavi 👋" 
  greeting (dynamic)
- Bell notification icon (top right)
- "VV" avatar circle (top right)
- Hero score card with 
  "74/100" + gold ring + "74%"
- "Scan Now →" button inside card
- Quick Stats: 4 cards
  (Moisture, UV Damage, 
   Skin Age, Texture)
- "Recent Insights" section 
  with "See All" link
- Insight pills 
  (Pore congestion, Hydration)
- Bottom nav bar:
  Home | Reports | Camera | 
  History | Profile

Button/tap actions:

Bell notification icon:
  → Navigate to 
    notifications.dart
  → Transition: slide down 
    from top

"VV" avatar circle:
  → Navigate to 
    user_profile_settings.dart
  → Transition: slide left

Hero card — "Scan Now →" button:
  → Navigate to 
    pre_scan_setup.dart
  → Transition: slide up

Hero card — tapping anywhere else:
  → Navigate to skin_report.dart
    (shows last scan)

Quick Stats cards (all 4):
  → Each card tap navigates to 
    skin_report_detail.dart
  → Pass parameter: 
    which parameter to highlight
  Example: 
    Moisture card → opens report 
    with Moisture tab active

"See All" link (Recent Insights):
  → Navigate to 
    scan_history.dart

Insight pills tap:
  → Navigate to 
    skin_report_detail.dart
  → Highlight relevant parameter

Bottom Navigation Bar:
  Home icon (active):
    → Already on home, 
      scroll to top
  
  Reports icon (bar chart):
    → Navigate to 
      skin_report.dart
  
  Camera icon (center, teal circle):
    → Navigate to 
      pre_scan_setup.dart
    → Transition: slide up
    → This is the primary CTA
  
  History icon (clock/history):
    → Navigate to 
      progress_tracker.dart
  
  Profile icon (person):
    → Navigate to 
      user_profile_settings.dart

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 6 — PRE-SCAN SETUP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: pre_scan_setup.dart

Elements visible in image:
- Back arrow (top left)
- "Scan Setup" title
- Circuit-face AR illustration 
  (center)
- 3 checklist items:
  "Good lighting detected"
  "Face centered in frame"
  "Camera permissions granted"
- "For best results" tip card
- "Ready to Scan" heading
- "Hold still for 30 seconds" 
  subtext
- "Begin AR Scan" teal button
- Step indicator at bottom:
  Setup → Scanning → Results

Button actions:

Back arrow:
  → Navigator.pop()
  → Returns to home_dashboard

Checklist items (auto, not tapped):
  → On screen load:
      Check camera permissions:
        IF granted → 
          "Camera permissions granted"
          shows checkmark ✓
        IF not granted →
          Show "Grant Permission" 
          text in place of checkmark
          On tap → request permission
      Check ambient light:
        Use camera preview to 
        estimate brightness
        IF good → checkmark
        IF too dark → warning icon
          Show tip: "Move to 
          better lighting"
      Face centering:
        Starts as pending
        Will confirm on AR screen

"For best results" tip card:
  → Not tappable, just info

"Begin AR Scan" button:
  → Check if camera permission 
    is granted
  → IF not granted:
      Request camera permission
      If denied: show dialog
      "Camera access required 
      for skin analysis"
      with "Open Settings" button
  → IF granted:
      Navigate to 
      ar_analysis.dart
      Transition: slide up, 
      full screen, 400ms

Step indicator:
  → "Setup" dot is active/gold
  → "Scanning" and "Results" 
    are inactive gray
  → Not tappable

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 7 — AR ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: ar_analysis.dart

Elements visible in image:
- Back arrow (top left, circle)
- "ANALYZING..." status pill 
  (center top, teal)
- Flash/torch icon (top right, circle)
- 3D face mesh on camera feed
- Bottom panel:
    "Scanning Parameters" title
    "Step 2 of 3: Deep Tissue Analysis"
    "68%" progress counter
    Progress bar (teal)
    4 parameter cards visible:
      Acne 12%, Pores 45%,
      Moisture 78%, Wrinkles 22%
    "Hold still..." instruction bar

Button actions:

Back arrow (top left):
  → Show confirmation dialog:
    "Cancel Scan?"
    "Your scan progress will be lost"
    Buttons:
      "Continue Scanning" → dismiss
      "Cancel" → Navigator.pop()
        → Returns to pre_scan_setup
  → Transition: slide down

Flash/torch icon (top right):
  → Toggle device torch:
    ON state: gold icon color
    OFF state: white icon color
  → Use camera plugin torch method

Parameter cards (4 visible, 
should be 9 total):
  → NOT tappable during scan
  → They update automatically 
    as scan processes
  → Show real-time values from 
    ML Kit + OpenCV analysis

"Hold still..." instruction bar:
  → Not tappable
  → Text cycles every 3 seconds

Progress reaches 100%:
  → Auto-navigate to 
    scan_processing.dart
  → No user action needed
  → Transition: slide up

Step indicator (Setup→Scanning→Results):
  → "Scanning" dot now active/gold
  → Not tappable

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 8 — SCAN PROCESSING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: scan_processing.dart

Elements:
- No back button (intentional)
- Animated rings + face icon
- "Analyzing Your Skin" text
- Cycling parameter text
- Progress bar
- 9 parameter chips 
  (pending/processing/complete)
- Lock icon + privacy note

Button actions:

No buttons — fully automatic screen

On screen load:
  → Start processing animation
  → Chips cycle through 
    pending → processing → complete
  → Progress bar fills 0→100%

On completion (all 9 done):
  → Show "Analysis Complete!" state
  → Gold checkmark animation
  → "View My Skin Report" button 
    appears after 1.2s

"View My Skin Report" button:
  → Navigate to skin_report.dart
  → Pass all 9 parameter scores 
    as arguments
  → Transition: slide up

Android back button:
  → Disabled on this screen
  → Use WillPopScope to block

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 9 — SKIN REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: skin_report.dart

Elements visible in image:
- Back arrow (top left)
- "Your Skin Report" title
- "Scanned on April 22, 2026"
- Overall score card: 
  "74/100" + gold ring + 
  "Good Skin Health"
- 9 parameter cards:
  Each has: icon, name, 
  description, severity badge
  (Good/Mild/Moderate/Action/
   Healthy/High/Young)
- "View Personalized 
  Recommendations →" teal button
- "Share Report" outlined button

Button actions:

Back arrow:
  → Navigator.pop()
  → Returns to previous screen
    (either home or scan processing)

Overall score card tap:
  → No action / not tappable

Each of 9 parameter cards tap:
  → Navigate to 
    skin_report_detail.dart
  → Pass parameter:
      parameterName: "Redness"
      parameterScore: 85
      parameterStatus: "Healthy"
      parameterDescription: 
        "Low sensitivity detected"

ADD THIS BUTTON to this screen:
  "View in AR" button
  (between score card and 
   parameter list)
  Teal outlined button, 
  full width
  Left icon: AR/camera icon
  Text: "View Problem Zones in AR"
  → Navigate to 
    ar_report_view.dart
  → Pass all 9 parameter results
  → Transition: slide up, 
    full screen

"View Personalized 
Recommendations →" button:
  → Navigate to 
    personalized_recommendations.dart
  → Pass scan results as arguments
  → Transition: slide left

"Share Report" button:
  → Trigger Flutter Share sheet
  → Generate report summary text
  → Share as text or PDF
  → Use share_plus package

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 10 — SKIN REPORT DETAIL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: skin_report_detail.dart

Elements visible in image:
- Back arrow (top left)
- Background: blurred face photo
- "Your Skin Report" heading
- X close button (top right circle)
- Overall Health Score card: 
  "78%" + gold ring
- 2 parameter mini cards:
  Acne (Low, 25%) 
  Dryness (High, 53%)
- "Recommended Routine" section 
  with "See All" link
- 3 routine items:
  Organic Cleanser, 
  Vitamin C Glow Serum,
  Deep Hydration Barrier
- "Save to History" teal button

Button actions:

Back arrow AND X close button:
  → Both do Navigator.pop()
  → Return to skin_report.dart

Parameter mini cards 
(Acne, Dryness):
  → Tap to expand inline
  → Show more detail below card
  → Or navigate to full 
    parameter detail page

"See All" link 
(Recommended Routine):
  → Navigate to 
    personalized_recommendations.dart

Routine item rows 
(Organic Cleanser etc):
  → Each row tap navigates to
    ingredient_detail.dart
  → Pass ingredient name
  → Transition: slide left

Chevron ">" on each routine item:
  → Same as row tap above

"Save to History" button:
  → Save current scan result 
    to local database (Hive/SQLite)
  → Show success snackbar:
    "✓ Report saved to your 
    skin history"
  → Button changes to:
    "✓ Saved" disabled state
  → Then after 1.5s navigate to 
    home_dashboard.dart

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 11 — SKINCARE ROUTINE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: skincare_routine.dart

Elements visible in image:
- Back arrow (top left)
- "Your Routine" title
- Settings gear icon (top right)
- "Today" / "Tomorrow" toggle tabs
- Morning Routine section:
    Checkmark circles on left
    Timeline vertical line
    Step cards: time + name
    Expandable cards (Vitamin C 
    Serum is expanded showing 
    description + Check-In button)
- Night Routine section:
    Same layout
    Oil Cleanser, Retinol Complex
- Bottom navigation bar

Button actions:

Back arrow:
  → Navigator.pop()

Settings gear (top right):
  → Navigate to 
    edit_profile.dart
    OR routine_settings.dart
  → For editing routine preferences

"Today" tab:
  → Show today's routine steps
  → Already active in image

"Tomorrow" tab:
  → Show tomorrow's routine steps
  → Switch tab content

Checkmark circle (left of each step):
  → Completed state: 
    filled teal circle + white tick
  → Incomplete state: 
    empty circle outline
  → On tap: toggle completed state
  → Save completion to local DB

Each step card (collapsed):
  → Tap card to expand
  → Shows ingredient description
  → Shows "Check-In" button
  → Chevron rotates 180° on expand

Each step card (expanded):
  → Tap again to collapse
  → OR tap chevron to collapse

"Check-In" teal button 
(inside expanded card):
  → Mark step as completed
  → Checkmark circle fills teal
  → Card collapses back
  → Show micro animation: 
    green pulse on checkmark
  → Save to progress tracker

Bottom navigation bar:
  Home → home_dashboard.dart
  Reports → skin_report.dart
  Camera (center) → pre_scan_setup.dart
  Sparkle icon → skincare_routine.dart
    (this screen, already active)
  Profile → user_profile_settings.dart

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 12 — PERSONALIZED 
RECOMMENDATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: personalized_recommendations.dart

Elements visible in image:
- Back arrow + "Your Routine" title
- "Based on your scan — 6 
  ingredients recommended" subtext
- Morning Routine section:
    Niacinamide 10% card:
      "Why?" button (outlined)
      "Oil Control" "Brightness" chips
      "98% match ✓"
- Evening Routine section:
    Retinol 0.3% card
    Azelaic Acid 10% card
    Ceramide Complex card
    Each with "Why?" + match %
- Weekly Treatments section:
    AHA/BHA Exfoliant card
- "Save Routine" teal button
- Disclaimer text at bottom

ADD THIS BUTTON (from our plan):
  "See Your Skin After Treatment"
  Outlined teal button above 
  "Save Routine"
  AR camera icon on left

Button actions:

Back arrow:
  → Navigator.pop()
  → Returns to skin_report.dart

"Why?" button on each card:
  → Show bottom sheet modal
  → Contains explanation of 
    why this ingredient was 
    recommended for this user
  → Based on their specific 
    scan results
  → "Got it" button dismisses

Benefit chips 
("Oil Control", "Brightness"):
  → Not tappable, decorative

"98% match ✓" / match scores:
  → Not tappable, informational

Each ingredient card body tap:
  → Navigate to 
    ingredient_detail.dart
  → Pass: ingredient name, 
    concentration, targets, 
    match score
  → Transition: slide left

"See Your Skin After Treatment" 
button (NEW — add this):
  → Navigate to 
    ar_treatment_preview.dart
  → Transition: slide up, 
    full screen

"Save Routine" teal button:
  → Save routine to local DB
  → Show success animation
  → Snackbar: "✓ Routine saved! 
    We'll remind you daily."
  → Navigate to 
    skincare_routine.dart
  → Transition: slide left

Disclaimer text:
  → Not tappable

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 13 — PROGRESS TRACKER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: progress_tracker.dart

Elements visible in image:
- Back arrow (top left)
- "Skin Journey" title
- Share icon (top right)
- Overall Skin Score card:
    "74/100" + "+6 pts since 
    last scan" green chip
    Gold progress ring
    3 mini stats: 
    Scans Done(4), 
    Best Score(78), 
    Streak(3wks)
- Time range tabs:
    1 Month | 3 Months | 
    6 Months | All
- "Score Over Time" line chart
- "Parameter Breakdown" section:
    Moisture Level +12%
    Wrinkles -2%
    Pore Congestion +8%
    Pigmentation Stable
- "Past Scans" timeline:
    Apr 22 LATEST — Score 74
    Apr 15 — Score 70
    Apr 08 — Score 72
- "Start New Scan" teal button
- Bottom navigation bar

Button actions:

Back arrow:
  → Navigator.pop()

Share icon (top right):
  → Generate progress summary
  → Open Flutter share sheet
  → Share as image or text

Time range tabs:
  "1 Month" → filter chart 
    to last 30 days data
  "3 Months" → last 90 days
  "6 Months" → last 180 days
  "All" → all scan history
  → Active tab: teal filled
  → Chart updates accordingly

Score Over Time chart:
  → Each data point tappable
  → On tap: show tooltip with
    "Score: 74 | Apr 22"
  → Tooltip: white card, 
    soft shadow, DM Sans 13px

Parameter Breakdown rows:
  Each row tap:
  → Navigate to 
    skin_report_detail.dart
  → Show that specific 
    parameter history

"+12%" / "-2%" change badges:
  → Not tappable, informational

Past Scans timeline:

  Each scan card tap:
  → Navigate to skin_report.dart
  → Load that specific 
    historical scan data
  → Pass: scan date and scan ID

  "LATEST" badge:
  → Not tappable, just indicator

  Score circle (74, 70, 72):
  → Tap → same as card tap above

"Start New Scan" teal button:
  → Navigate to 
    pre_scan_setup.dart
  → Transition: slide up

Bottom navigation bar:
  Home → home_dashboard.dart
  Reports → skin_report.dart
  Camera (center teal) → 
    pre_scan_setup.dart
  History/trending (active) → 
    Already on this screen,
    scroll to top
  Profile → 
    user_profile_settings.dart

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREEN 14 — USER PROFILE 
& SETTINGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: user_profile_settings.dart

Elements visible in image:
- Back arrow (top left)
- "Profile" title (center)
- Edit/pencil icon (top right)
- "VS" avatar circle with 
  gold ring border
- "Vaishnavi Sharma" name
- "Member since Oct 2023"
- 3 stat badges:
    24 Total Scans | 
    74 Skin Score | 
    85% Routine
- ACCOUNT SETTINGS section:
    Personal Information →
    Scan History →
    My Routine →
- PRIVACY & SECURITY section:
    Data Encryption →
    Privacy Mode →
    Notifications →
- SUPPORT section:
    Help Center →
    Terms of Service →
- "Sign Out" outlined button
- "DermaScan AI v2.4.0" 
  version text

Button actions:

Back arrow:
  → Navigator.pop()

Edit/pencil icon (top right):
  → Navigate to 
    edit_profile.dart
  → Transition: slide up 
    (modal style)

Avatar circle tap:
  → Same as edit icon
  → Navigate to edit_profile.dart

Stats (24 scans, 74 score, 85%):
  Total Scans tap:
    → Navigate to scan_history.dart
  Skin Score tap:
    → Navigate to 
      skin_report.dart (latest)
  Routine % tap:
    → Navigate to 
      skincare_routine.dart

ACCOUNT SETTINGS rows:

"Personal Information" row:
  → Navigate to edit_profile.dart
  → Transition: slide left

"Scan History" row:
  → Navigate to scan_history.dart
  → Transition: slide left

"My Routine" row:
  → Navigate to 
    skincare_routine.dart
  → Transition: slide left

PRIVACY & SECURITY rows:

"Data Encryption" row:
  → Navigate to 
    data_encryption_info.dart
  OR show bottom sheet with 
  encryption details

"Privacy Mode" row:
  → Toggle switch behavior:
    ON: blur scan images in history
    OFF: show full images
  → Save preference to 
    SharedPreferences

"Notifications" row:
  → Navigate to 
    notifications_settings.dart
  OR navigate to 
    notifications.dart
  → Transition: slide left

SUPPORT rows:

"Help Center" row:
  → Launch URL in webview
  → OR navigate to 
    help_center.dart

"Terms of Service" row:
  → Launch URL in webview
  → OR navigate to 
    terms_of_service.dart

"Sign Out" outlined button:
  → Show confirmation dialog:
    "Sign Out?"
    "You will need to sign in 
    again to access your 
    skin data"
    Buttons:
      "Cancel" → dismiss dialog
      "Sign Out" → 
        Clear SharedPreferences:
          'is_logged_in' = false
          clear user data
        Navigate to sign_in.dart
        Replace all routes 
        (no back stack)

Version text "DermaScan AI v2.4.0":
  → Not tappable
  → Pull version from 
    pubspec.yaml dynamically

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NEW SCREENS TO CREATE IN DEV
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ar_report_view.dart
  Entry: From skin_report.dart
    "View Problem Zones in AR"
  Exit options:
    X button → Navigator.pop()
    "View Recommendations" → 
      personalized_recommendations
  Receives: all 9 scan results
  Shows: Live camera + colored 
    overlays pinned to face zones

ar_treatment_preview.dart
  Entry: From 
    personalized_recommendations
    "See Your Skin After Treatment"
  Exit options:
    X button → Navigator.pop()
    "Save Routine" → 
      skincare_routine.dart
  Shows: Live camera + 
    smoothing filter overlay

forgot_password.dart
  Entry: From sign_in.dart
  Exit: Back → sign_in.dart
  Flow: Email → OTP → 
    Reset Password → sign_in

otp_verification.dart
  Entry: From sign_up.dart 
    or forgot_password.dart
  Exit: 
    From signup: → home_dashboard
    From forgot: → reset_password
  Actions:
    6-digit OTP input
    "Verify & Continue" button
    "Resend Code" (after timer)

scan_history.dart
  Entry: From profile or 
    home dashboard "See All"
  Exit: Back → previous screen
  Each scan card → skin_report.dart

ingredient_detail.dart
  Entry: From recommendations
    or skincare routine
  Exit: Back → previous screen
  "Add to Routine" → 
    skincare_routine.dart

edit_profile.dart
  Entry: From profile screen
  Exit: 
    "Cancel" → Navigator.pop()
    "Save" → Navigator.pop()
      with success snackbar

notifications.dart
  Entry: From bell icon 
    on home dashboard
  Exit: Back → home_dashboard
  Each notification tap → 
    relevant screen

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GLOBAL NAVIGATION RULES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Bottom Nav Bar behavior:
  Present on screens:
    home_dashboard ✅
    skin_report ✅
    skincare_routine ✅
    progress_tracker ✅
    user_profile_settings ✅
  
  NOT present on screens:
    splash ❌
    onboarding ❌
    sign_up ❌
    sign_in ❌
    pre_scan_setup ❌
    ar_analysis ❌
    scan_processing ❌
    ar_report_view ❌
    ar_treatment_preview ❌
    forgot_password ❌
    otp_verification ❌

Route replacement rules:
  After login → replace all routes
    (user cannot back to login)
  After logout → replace all routes
    (user cannot back to app)
  Scan flow → push on stack
    (user can back out)

Android hardware back button:
  Disabled on:
    scan_processing.dart
    ar_analysis.dart (during scan)
  Confirmation dialog on:
    ar_analysis.dart (if scan active)
  Normal behavior on:
    all other screens

Loading states:
  All API calls → show 
    CircularProgressIndicator
    on the button that was tapped
    Disable button while loading
    Re-enable on error

Error handling:
  Network errors → snackbar:
    "Connection failed. 
    Please check your internet."
  Auth errors → snackbar:
    specific error message
  Scan errors → dialog with 
    "Try Again" option

Data passing between screens:
  Use constructor arguments 
  for passing scan results
  Use Provider or Riverpod 
  for global state:
    currentUser (UserModel)
    latestScanResult (ScanModel)
    savedRoutine (RoutineModel)