# Suggested Improvements

This document discusses improvements to the mobile Evacuation Drill Participation App which the initial development team can foresee but does not have the resources to implement. There is some overlap with the documented [Issues](issues), but there are also complex improvements which have not yet been documented as Issues.

## Acquire GPS Signal before Drill Start

Currently the trajectory data has significant errors from beginning location tracking at the same moment as Drill Start. Begin location tracking before Drill Start, and only signal "ready" to server once noise in location data stream is below a threshold (5 meters? 10?).

## Persistence

(app currently loses all data on close/crash)

## Manually Handle Upload Errors when No Connectivity

Firebase handles lack of connectivity when attempting to upload and syncs once connectivity restored, but we should not rely on this (and should inform user if results did not successfully upload).

## Allow Drill Event to be Joined Prior to Time of Event

(need to save data persistently and provide a way to access at a later date)

## Allow Multiple Drill Events to be Joined Prior to Time of Event

## Start Drill on Researcher Signal

(currently on three second timer)

## Allow other Research Teams to use our Apps for their Drill Events

Need to change the way that the Cloud Backend works (and potentially remove Firebase integration) to allow any research team to set up their own cloud backend for their own drills. Will also need to change how Drill Events are distributed (QR code scan to download link for Drill Event json, validate then parse?)

