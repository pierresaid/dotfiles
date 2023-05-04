#!/usr/bin/expect -f

spawn rm -rf vtest
expect eof

spawn npm init vue@latest vtest

expect "Add TypeScript?" { send "\033\[C"; send "\r" }
expect "Add JSX Support?" { send "\r" }
expect "Add Vue Router for Single Page Application development?" { send "\033\[C"; send "\r" }
expect "Add Pinia for state management?" { send "\033\[C"; send "\r" }
expect "Add Vitest for Unit Testing?" { send "\r" }
expect "Add an End-to-End Testing Solution?" { send "n\r"}
expect "Add ESLint for code quality?" { send "\r"; exp_continue }