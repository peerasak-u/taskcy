# Taskcy Mock Data Plan

## Overview

This document outlines the comprehensive plan for realistic mock data in Taskcy, designed to create an authentic project management experience for demos and development. The data is mutable during runtime but resets on each app launch.

## Data Architecture Strategy

### Storage Approach
- **Non-persistent**: Data lives in memory only, resets on app restart
- **Mutable**: All CRUD operations work during runtime
- **Realistic**: Based on actual development scenarios
- **Demo-optimized**: Strategically timed for effective screen demonstrations

### Service Layer Changes
- Remove SharedPreferences persistence from all local services
- Use static in-memory collections initialized on first access
- Maintain existing service interfaces for seamless integration
- Enable real-time data manipulation without persistence

## User Profiles (4 Users)

### 1. Peerasak (Primary User - You)
- **ID**: `user_peerasak`
- **Email**: `peerasak.dev@example.com`
- **Full Name**: `Peerasak`
- **Avatar**: Custom avatar URL or initials `P`
- **Role**: Project owner, developer, team lead

### 2. Claude (AI Assistant)
- **ID**: `user_claude`
- **Email**: `claude@anthropic.ai`
- **Full Name**: `Claude`
- **Avatar**: AI-themed avatar or initials `C`
- **Role**: AI assistant, development partner

### 3. Sarah Chen (Marketing Lead)
- **ID**: `user_sarah`
- **Email**: `sarah.chen@creativeworks.com`
- **Full Name**: `Sarah Chen`
- **Avatar**: Professional avatar or initials `SC`
- **Role**: Marketing strategist, brand specialist

### 4. Alex Rivera (Designer)
- **ID**: `user_alex`
- **Email**: `alex.rivera@creativeworks.com`
- **Full Name**: `Alex Rivera`
- **Avatar**: Design-themed avatar or initials `AR`
- **Role**: UI/UX designer, visual creator

## Team Structure (3 Teams)

### 1. AxenTech
- **ID**: `team_axentech`
- **Privacy**: Private
- **Owner**: Peerasak
- **Members**: Peerasak, Claude
- **Description**: "Flutter development team for AxenTech assignment project"
- **Purpose**: Handles the AxenTech assignment project with learning-focused tasks

### 2. Pygmy Migration
- **ID**: `team_pygmy`
- **Privacy**: Private  
- **Owner**: Peerasak
- **Members**: Peerasak, Claude
- **Description**: "Dedicated team for migrating Pygmy app from iOS to Flutter"
- **Purpose**: Manages the complex migration project with technical challenges

### 3. CreativeWorks Studio
- **ID**: `team_creativeworks`
- **Privacy**: Public
- **Owner**: Sarah Chen
- **Members**: Peerasak, Claude, Sarah Chen, Alex Rivera
- **Description**: "Multi-disciplinary team for creative and marketing projects"
- **Purpose**: Demonstrates non-development work and larger team collaboration

## Project Portfolio (3 Main Projects + 1 Personal)

### 1. AxenTech Assignment
- **Team**: AxenTech
- **Owner**: Peerasak
- **Duration**: 4-6 weeks
- **Status**: Active development (65% complete)
- **Focus**: Learning and foundational development
- **Due Date**: 3 weeks from today

### 2. Migrate Pygmy to Flutter
- **Team**: Pygmy Migration
- **Owner**: Peerasak  
- **Duration**: 12-16 weeks
- **Status**: Early development (30% complete)
- **Focus**: Complex technical migration
- **Due Date**: 3 months from today

### 3. Brand Identity Campaign
- **Team**: CreativeWorks Studio
- **Owner**: Sarah Chen
- **Duration**: 8-10 weeks
- **Status**: Mid-stage execution (85% complete)
- **Focus**: Marketing and creative work (non-development)
- **Due Date**: 2 weeks from today

### 4. Personal Productivity Tools
- **Team**: AxenTech (smaller scope)
- **Owner**: Peerasak
- **Duration**: 2-3 weeks
- **Status**: Planning stage (15% complete)
- **Focus**: Personal utility development
- **Due Date**: 6 weeks from today

## Task Distribution Strategy

### Timing Base: August 6, 2025

### AxenTech Assignment Tasks (5 tasks)
1. **Learn Flutter fundamentals** ✅ 
   - Status: Completed
   - Completed: Aug 3, 2025 (3 days ago)
   - Priority: High
   - Assignee: Peerasak

2. **Setup project structure** 🔄
   - Status: In Progress  
   - Started: Aug 4, 2025
   - Due: Aug 7, 2025 (tomorrow)
   - Priority: High
   - Assignee: Peerasak
   - Progress: 75%

3. **Research state management patterns** 📋
   - Status: To Do
   - Due: Aug 9, 2025
   - Priority: Medium
   - Assignee: Claude

4. **Implement core UI components** 🔄
   - Status: In Progress
   - Started: Aug 5, 2025
   - Due: Aug 12, 2025
   - Priority: High
   - Assignee: Peerasak
   - Progress: 40%

5. **Craft typography and visual design** 📋
   - Status: To Do
   - Due: Aug 15, 2025
   - Priority: Medium
   - Assignee: Claude

### Pygmy Migration Tasks (6 tasks)
1. **Setup new Flutter project with guidelines** 🔄
   - Status: In Progress
   - Started: Aug 5, 2025
   - Due: Aug 8, 2025
   - Priority: Urgent
   - Assignee: Peerasak
   - Progress: 60%

2. **Bridge Vision Framework to Flutter** 📋
   - Status: To Do
   - Due: Aug 20, 2025
   - Priority: High
   - Assignee: Claude

3. **Migrate database from SwiftData to SQLite** 📋
   - Status: To Do
   - Due: Aug 25, 2025
   - Priority: High
   - Assignee: Peerasak

4. **Research Android OCR solutions** 📋
   - Status: To Do
   - Due: Aug 18, 2025
   - Priority: Medium
   - Assignee: Claude

5. **Implement core features migration** 📋
   - Status: To Do
   - Due: Sept 15, 2025
   - Priority: High
   - Assignee: Peerasak

6. **Design and craft UI** 📋
   - Status: To Do
   - Due: Oct 1, 2025
   - Priority: Medium
   - Assignee: Claude

### Brand Identity Campaign Tasks (6 tasks)
1. **Market research and competitor analysis** ✅
   - Status: Completed
   - Completed: July 28, 2025
   - Priority: High
   - Assignee: Sarah Chen

2. **Design brand logo concepts** ✅
   - Status: Completed
   - Completed: Aug 1, 2025
   - Priority: High
   - Assignee: Alex Rivera

3. **Create comprehensive brand style guide** 🔄
   - Status: In Progress
   - Started: Aug 2, 2025
   - Due: Aug 8, 2025
   - Priority: High
   - Assignee: Alex Rivera
   - Progress: 90%

4. **Develop marketing materials** ✅
   - Status: Completed
   - Completed: Aug 4, 2025
   - Priority: Medium
   - Assignee: Sarah Chen

5. **Launch social media campaign** 🔄
   - Status: In Progress
   - Started: Aug 5, 2025
   - Due: Aug 10, 2025
   - Priority: Urgent
   - Assignee: Sarah Chen
   - Progress: 70%

6. **Measure campaign effectiveness** 📋
   - Status: To Do
   - Due: Aug 25, 2025
   - Priority: Medium
   - Assignee: Sarah Chen

### Personal Productivity Tools Tasks (3 tasks)
1. **Define requirements and scope** 🔄
   - Status: In Progress
   - Started: Aug 6, 2025 (today)
   - Due: Aug 10, 2025
   - Priority: Low
   - Assignee: Peerasak
   - Progress: 30%

2. **Create wireframes and mockups** 📋
   - Status: To Do
   - Due: Aug 18, 2025
   - Priority: Low
   - Assignee: Peerasak

3. **Develop MVP features** 📋
   - Status: To Do
   - Due: Sept 1, 2025
   - Priority: Medium
   - Assignee: Peerasak

## Timeline Distribution for Demo

### Today (Aug 6, 2025) - Timeline View Demo
- **9:00 AM**: Setup project structure (AxenTech) - In Progress
- **11:00 AM**: Define requirements and scope (Personal) - In Progress  
- **2:00 PM**: Create brand style guide (Brand Identity) - In Progress
- **4:00 PM**: Launch social media campaign (Brand Identity) - In Progress

### This Week - Calendar View Demo
- **Aug 7**: Setup project structure (AxenTech) - Due
- **Aug 8**: Setup Flutter project (Pygmy), Brand style guide (Brand Identity) - Due
- **Aug 9**: Research state management (AxenTech) - Due
- **Aug 10**: Define requirements (Personal), Social media campaign (Brand Identity) - Due

### Overdue Tasks (Realistic PM scenario)
- **Bridge Vision Framework** - Originally due Aug 5, now overdue by 1 day (shows realistic project delays)

## Screen-Specific Data Requirements

### Home Screen Demo Needs
- **Project Cards**: 3-4 projects with varying progress (30%, 65%, 85%)
- **Team Avatars**: Mix of initials and avatar images for visual variety
- **In Progress Tasks**: 3-4 tasks with recent activity timestamps
- **Progress Colors**: Different colors based on urgency/status

### Task List Screen Demo Needs
- **Timeline View**: Tasks scheduled at realistic business hours
- **Calendar View**: Tasks distributed across current week with visual density
- **Date Navigation**: Tasks for past, present, and future dates
- **Task Counts**: Realistic daily task distribution (1-4 tasks per day)

### Project Screen Demo Needs
- **Project Details**: Name, description, team members, progress
- **Task Lists**: Organized by status with realistic distribution
- **Team Member Cards**: Profile images, roles, activity status
- **Progress Tracking**: Completion percentages, milestones, deadlines

### Chat Screen Demo Needs
- **Team Context**: Team member lists for conversation routing
- **Recent Activity**: Message threads based on project activity
- **Online Status**: Team member availability indicators

### Profile Screen Demo Needs
- **User Profile**: Complete profile information with avatar
- **Team Memberships**: List of teams user belongs to
- **Activity History**: Recent task completions and project updates
- **Settings**: Preferences and notification settings

## Data Relationships & Integrity

### User-Team Relationships
- Peerasak: Member of all 3 teams (owner of 2)
- Claude: Member of AxenTech and Pygmy Migration
- Sarah Chen: Owner of CreativeWorks Studio
- Alex Rivera: Member of CreativeWorks Studio only

### Team-Project Relationships
- AxenTech team: 2 projects (AxenTech Assignment, Personal Tools)
- Pygmy Migration team: 1 project (Pygmy Migration)
- CreativeWorks Studio: 1 project (Brand Identity Campaign)

### Project-Task Relationships
- Each project has 3-6 tasks with realistic progression
- Tasks assigned to appropriate team members based on skills
- Due dates spread across realistic timeline
- Status distribution: 30% completed, 40% in-progress, 30% todo

## Demo Story Flow

### Week Overview Narrative
- **Monday-Tuesday**: Project setup and planning activities
- **Wednesday-Thursday**: Active development and design work
- **Friday**: Review, testing, and campaign launches
- **Weekend**: Personal project time and planning

### Progress Narrative
- **AxenTech Assignment**: Learning phase transitioning to implementation
- **Pygmy Migration**: Early setup with technical research ahead
- **Brand Identity**: Near completion with campaign launch in progress  
- **Personal Tools**: Just starting with requirement gathering

This creates a cohesive, realistic ecosystem that tells the story of active software development teams while providing rich data for demonstrating all app features effectively.