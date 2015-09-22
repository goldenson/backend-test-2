# [Aircall.io](https://aircall.io) - Backend technical test

This test is a part of our hiring process at Aircall for [backend positions](https://aircall.io/jobs#BackendDeveloper).

__Feel free to apply! Drop us a line with your Linkedin/Github/Twitter/AnySocialProfileWhereYouAreActive at jobs@aircall.io__

## Summary

The purpose of the test is to reproduce one of our typical use case on the backend part of Aircall: __call forwarding__.

The story is the following:

- Jane (CEO), Peter (CTO) and Luke (COO) are in the same company.
- The company has 3 different phone numbers: Main Office (everybody can answer the calls on this line), Sales number (only Jane and Luke will answer calls on this line) and Support number (only Peter and Luke will answer calls on this line).
- The company is using Aircall in order to manage its calls! Currently they are using two features of Aircall: call forwarding (see strategies below) and call history.
- Jane is connected to her Aircall App on two different devices (mobile phone and desktop computer). Peter is connected to Aircall with his desktop computer and Luke is not connected at all.

It's 9AM in the office and first calls are coming in!

## Instructions

### Code

In this repository you'll find a simple Rails project with some models: 

- _User_ : the Aircall users. We won't use a Company model in this test, so User is the main object in the hierarchy.
- _CompanyNumber_ : it represents the lines of the company (the previous Main office, Support number and Sales number for example)
- _UserNumber_ : it represents the devices of each User (mobile phones, desktop computers...)

In order to make and route calls, you'll extend this Rails project by creating an interaction with [Plivo](https://plivo.com)'s API. You'll only use SIP endpoints and we'll consider that the lines of the company (Main Office, Sales number, Support number) are SIP endpoints too. Callers will launch calls from SIP endpoints as well.

Please keep these points in mind:

- The focus of this test should be the interaction between your Rails server and Plivo on incoming calls. Do not customize forms or views in order to modify models (except if it helps you to test) - it's a test for backend developers.
- Use a seeds.rb file in order to fill the database because I will launch the rake task _db:seed_.
- You can add the models you need.
- Do not add tests in your submission, except if you have extra time.
- You can add as many gems as you want or change the ruby version.
- Prepare deployment of your project on a simple Heroku dyno (for example).
- In order to test the interaction between Plivo and your local environment, you can use tunnels like ngrok.com.
- If you're on Mac, use the free [Telephone](http://www.tlphn.com/) application in order to register to SIP endpoints. For other systems, there are a lo of free SIP client too.
- You'll have three types of SIP endpoints: one for the caller, one for the company's line and one for the users' devices. 
- For the caller's SIP endpoint you can use the [Direct Dial](https://www.plivo.com/docs/getting-started/sip-endpoint/) App on Plivo. This endpoint used is not part of your system and will only be used to call the company's number.
- You don't need to handle outbound calls from users' devices, but only inbound calls. So you can use the Direct Dial App for these endpoints too.
- Your system has to be extendable. It should work the same way if we add users, numbers or devices.


### Use case

Each device of each user has registered to a different SIP endpoint and they will get calls through these SIP endpoints.

The use case we want to reproduce is the following:

- A customer is calling one of the number of the company.
- Depending on the number called, the call has to be redirected to the right devices (for example, a call on the Support number won't be redirected to Jane's devices).
- If 2 or more people are available, the call need to be forwarded using a "cascading" strategy. For example, on the Main Office line, a call will be redirected to Jane first, and if she doesn't answer the call will be redirected to Peter, and if the call is still not answered it will be redirected to Luke. 
- If nobody took the call on a specific line, the caller will leave a voicemail.
- The call has to be logged in the database.

## Main steps

[ ] Create a Plivo account and read the doc.

[ ] Create SIP endpoints on Plivo for the caller and the users' devices.

[ ] Create Application and SIP endpoints you'll use for company's numbers.

[ ] Create a Call model in order to store call history and voicemails.

[ ] Create rules (described earlier) in your system.

[ ] Redirect incoming calls to users' devices by interacting with Plivo.

Contact us at jobs@aircall.io if you need more details.
