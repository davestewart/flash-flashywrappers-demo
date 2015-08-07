<?php

	// get path (differs from localhost to test server)
	$host	= $_SERVER['HTTP_HOST'];
	$root	= trim(str_replace('\\', '/', dirname($_SERVER['PHP_SELF'])), '/');
	$root	= trim($root) . '/';
	if ($root == '/')
	{
		$root = '';
	}
	
	// kill that
	//$host	= 'http://' . $_SERVER['HTTP_HOST'] . preg_replace('/[^\/]+\.php$/', '', $_SERVER['REQUEST_URI']);

	// variables
	$data	= file_get_contents('php://input');
	$name	= date("Y-m-d_H-i-s"); 
	$path	= "media/$name.mp4";

	// write data	
	file_put_contents($path, $data);
	//file_put_contents("media/$name.txt", utf8_decode($data));
	
	// result
	header('Content-Type: application/json');
	echo json_encode(array
	(
		'data' => array
		(
			'url'		=> 'http://' . $host . '/' . $root . $path,
			'length'	=> strlen($data)
		)
	));
	 