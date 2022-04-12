# oregon-state-evacuation-app

This repository contains the source code for a suite of technologies which enable the generation of survey and "trajectory" (location over time) datasets. These datasets are valuable to Civil Engineering evacuation traffic research. These technologies include:
- Evacuation Drill Participation App (dir: `evac_app` [link here?])
    - A mobile Flutter app written for iOS and Android which generates, encrypts, and uploads survey and trajectory datasets. 
- Evacuation Drill Researcher Console (not yet added)
    - A desktop Flutter app written for macOS (with future compilation possible for Web and Windows) which allows for the download, decryption, and parsing of survey and trajectory datasets.
- Description of Google Firebase/Cloud backend (not yet added)
    - While the source for our cloud backend remains private, we provide a description of techniques utilized to setup a primitive cloud backend for our technology suite using Google Cloud Products.

Please see the README in each subdirectory for more detailed descriptions of the technology listed above. Alternatively, the **[Drill Procedure](#drill-procedure)** section below walks through the process of creating, running, and gathering the results from an example evacuation drill event using this suite of technologies.

## Authors 

- Jasmine Snyder

- David Kaff

- Dingguo Tang

*link to emails?/github profiles?*

## Motivation

*insert description from previous writing, maybe design document?*

## Drill Procedure<a name="drill_procedure"></a>

*describe this section briefly, then fold the remainder…*

<!-- <details>
<summary>Click here to view drill procedure.</summary> -->

>### Creating the Drill Event
>
>…
>
>At this time, these details need to be manually inserted into the Firebase Firestore by the development team. A planned feature addition [link to issue] will allow researchers to input these details themselves via the **Evacuation Drill Researcher Console** [link?].
>
>…
>
>### Inviting Participants
>
>The current procedure for inviting participants to participate in an evacuation drill event is to craft a communication which relays the *what*, *when*, and *where* of the drill, along with *how* they can download the mobile participant app on their iOS or Android device. Currently, iOS distribution is via TestFlight [link to docs about inviting/generating links] and Android distribution is via manual `.apk` install [link to dev mode, .apk install docs].
>
>### Provide Invite Code to Participants
>
>Currently, participants should be invited to join the drill event from their mobile participant app only at the time of the event. In a planned feature addition [link to issue] users will be able to accept an invite prior to the time of the event, and the app will save the drill event details until the time of the event. In another planned feature addition [link to issue] researchers will be able to include meeting location and instructions in the drill event details, which will include a google maps link to the meeting location to assist participants in meeting the researchers on the day of the event. These details would also be stored in the app until the appropriate time.
>
>### Have Participants Complete Pre-Drill Survey
>
>### Bring Participants to Drill Start Location
>
>### Instruct Participants on Where to Regroup Following Drill Completion
>
>### Send **Start Signal** to Participants
>
>### Regroup with Participants and Have Them Complete Post-Drill Survey
>
>### Have Participants Upload Drill Results
>
>(trouble shooting, requirements for upload, what if they weren't connnect to internet when pressing "upload" (not a problem thanks to Firestore?))
>
>### Thanks Participants and Conclude Drill Event
>
>### Gather the Results



<!-- </details> -->

## Test Results

*after we complete a writeup on the testing, link to it here? potentially embed within repo?*
