<?php

	// variables
	$data	= file_get_contents('php://input');
	$name	= date("Y-m-d H-i-s"); 
	$path	= "media/$name.mp4";

	// write data
	file_put_contents($path, $data);
	//file_put_contents("media/$name.txt", utf8_decode($data));

	// result
	echo json_encode(array(
		'url'		=> 'http://localhost:8000/' . $path,
		'path'		=> $path,
		'length'	=> strlen($data)
	), JSON_UNESCAPED_SLASHES);
	 