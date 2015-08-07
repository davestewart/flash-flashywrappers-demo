<?php


echo 'http://' . $_SERVER['HTTP_HOST'] . preg_replace('/[^\/]+\.php$/', '', $_SERVER['REQUEST_URI']);
