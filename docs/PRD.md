# Taskcy

## Overview

This project is the mobile application that designed to do the project management like JIRA but more friendly UI

## Entity

This project has many main entity to dealing with as follow:

- **User**: user account contain fullname, email, authentication status, avatarUrl (simple user profile)
- **Team**: group of user like organization in JIRA it has `name`, `logoUrl` and `type` "Private|Public|Secret" and it can be link with user as a `teamMembers`
- **Project**: belong to `team` and it has `name` , and related to `tasks`
- **Task**: the atomic unit of work contain `name` , `teamMembers`, `startedAt`, `endedAt`, `project`, `status`(Completed|In Progress|To Do)

## Screens

- On Boarding with 4 steps inside
- Sign In and Sign Up page
- Main Scaffold with 4 sub tabs
  - Home
  - Project
  - Chat
  - Profile
- Shared screen
  - Add Menu: present on any screen after user tap on add button on custom navigation bar, it's dynamic height follow the content in it not display full screen and blurry backdrop when display
  - Add Task: can be push from any screen, full screen page after tapped on menu
  - Create Team: can be push from any screen, full screen page after tapped on menu
  - Create Project: can be push from any screen, full screen page after tapped on menu
- Sub page (push navigate) from Home
  - Today Task / Monthly Task
- Sub page (push navigate) from Profile
  - Settings
