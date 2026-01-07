# LiftNode V2 Roadmap

Items deferred from V1.2 that require significant implementation effort.

---

## 🎨 UI/UX Enhancements

### Light Theme Support
- **Phase:** 2.1
- **Reason:** Requires major redesign of all color tokens
- **Effort:** High

### Page Route Transitions (Slide/Fade)
- **Phase:** 7.2  
- **Reason:** Feature enhancement, not bug
- **Effort:** Medium

### Hero Animations Between Screens
- **Phase:** 7.2
- **Reason:** Requires adding Hero widgets across screens
- **Effort:** Medium

### Onboarding Flow for First-time Users
- **Phase:** 5.2
- **Reason:** New feature requiring design & implementation
- **Effort:** High

### Tutorial/Walkthrough
- **Phase:** 5.2
- **Reason:** New feature
- **Effort:** High

---

## 🏋️ Workout Features

### Drag-to-Reorder Exercises
- **Phase:** 6.1 / 7.1
- **Reason:** Requires ReorderableListView refactor
- **Effort:** Medium

### Delete Individual Sets
- **Phase:** 6.1
- **Reason:** Feature not implemented
- **Effort:** Low

### Set Types Selection (Warmup/Failure)
- **Phase:** 6.1
- **Reason:** UI exists, needs connection
- **Effort:** Low

### RPE Input
- **Phase:** 6.1
- **Reason:** Model exists, needs UI
- **Effort:** Low

### Notes Per Set
- **Phase:** 6.1
- **Reason:** New feature
- **Effort:** Medium

### Rest Timer Notification/Vibration
- **Phase:** 6.1
- **Reason:** Platform-specific implementation
- **Effort:** Medium

### Configurable Rest Timer from Profile
- **Phase:** 6.1
- **Reason:** Setting exists but not connected to timer
- **Effort:** Low

---

## 📊 Statistics & History

### Volume Progress Over Time Chart
- **Phase:** 6.1
- **Reason:** New visualization
- **Effort:** Medium

### Exercise-Specific History
- **Phase:** 6.1
- **Reason:** New feature
- **Effort:** Medium

---

## 📚 Exercise Library

### Exercise Images/Animations
- **Phase:** 6.2
- **Reason:** Asset heavy, requires content
- **Effort:** High

### Favorite Exercises
- **Phase:** 6.2
- **Reason:** New feature
- **Effort:** Low

### Recently Used Exercises
- **Phase:** 6.2
- **Reason:** New feature
- **Effort:** Low

### Delete Custom Exercise
- **Phase:** 6.2
- **Reason:** Missing functionality
- **Effort:** Low

---

## 👤 Profile & Settings

### Edit Profile (Name, Avatar)
- **Phase:** 6.2
- **Reason:** UI for editing not implemented
- **Effort:** Medium

### Achievements Unlock Logic
- **Phase:** 6.2
- **Reason:** Currently static badges
- **Effort:** High

### Level Calculation Logic
- **Phase:** 6.2
- **Reason:** XP/level system not implemented
- **Effort:** Medium

---

## 🏠 Home Dashboard

### Repeat Last Session
- **Phase:** 6.2
- **Reason:** Shows "coming soon" placeholder
- **Effort:** Medium

### Workout Templates
- **Phase:** 6.2
- **Reason:** Shows "coming soon" placeholder
- **Effort:** High

### Weekly Goals/Targets
- **Phase:** 6.2
- **Reason:** New feature
- **Effort:** Medium

---

## 🛡️ Technical Improvements

### Error Listener Memory Leak Fix
- **Phase:** 8.1
- **Reason:** Requires refactor to Consumer/Selector pattern
- **Effort:** Medium
- **Impact:** Low (not critical)

### Data Migration Strategy
- **Phase:** 4.2
- **Reason:** For future schema changes
- **Effort:** Medium

### Data Size Limit Management
- **Phase:** 4.2
- **Reason:** Prevent unlimited history growth
- **Effort:** Low

### Deep Linking Support
- **Phase:** 5.1
- **Reason:** Feature enhancement
- **Effort:** Medium

### Network Error Handling
- **Phase:** 8.1
- **Reason:** Not needed for offline-first app
- **Effort:** N/A

### Input Validation (kg/reps)
- **Phase:** 8.2
- **Reason:** Accepts any string currently
- **Effort:** Low

---

## Priority for V2 (Recommended Order)

### High Priority
1. Delete Individual Sets (Low effort, high impact)
2. Edit Profile UI (User expectation)
3. Favorite Exercises (Improves UX)
4. Configurable Rest Timer (Setting exists)

### Medium Priority
1. Set Types Selection
2. Drag-to-Reorder
3. Repeat Last Session
4. Light Theme

### Low Priority (Nice to Have)
1. Hero Animations
2. Achievements Unlock Logic
3. Workout Templates
4. Exercise Images

---

*Last updated: V1.2 Release*
