# Real-Time Programming Course.

**Streaming Twitter sentiment score analyzer**

## Description

This application receives 2 streams of tweets from Twitter API. Every tweet is being analyzed by the sentiment score analyzer and tweet text in pair with its score is stored in database After that the tweet is being published to the client by the __tweeter__ topic.

## Running

1. Run docker containers with `$ docker-compose up -d`
1. Connect with `$ netcat localhost 6666`
1. Subscribe to __tweeter__ topic. `SUBSCRIBE tweeter`

## Demonstration video
https://drive.google.com/file/d/1j7BVgFyusvGZuP0NlvNvW3xGm84ys7PG/view?usp=sharing