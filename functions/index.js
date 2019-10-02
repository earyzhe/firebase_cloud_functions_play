/* eslint-disable no-duplicate-case */
const functions = require('firebase-functions');
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

exports.getName = functions.https.onCall((data, context) => {
    return {
        "data" : "You hit the call at least!"
    };
});

exports.appAlive = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");
});

exports.isADick = functions.https.onRequest((request, response) => {

    const name = request.query.name || request.body.name;
    switch (name) {
        case 'Andrew':
            request.query.name ? response.send("Na he is the boi Q!") : response.send("Na he is the boi B!");
            break;

        case 'Brett':
            request.query.name ? response.send("Na just wierd! Q") : response.send("Na just wierd! B");
            break;

        case 'Eddie':
            request.query.name ? response.send("My brother but yeah! Q") : response.send("My brother but yeah! B");
            break;

        case 'James':
            request.query.name ? response.send("The biggest! Q") : response.send("The biggest! B");
            break;

        default:
            request.query.name ? response.send("Dunno who that is! Q") : response.send("Dunno who that is! B");
            break;
    }
});