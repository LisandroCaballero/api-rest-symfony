<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;


class UserController extends AbstractController
{

    public function index()
    {
        return $this->json([
            'message' => 'Vamos a crear los usuarios',
            'path' => 'src/Controller/UserController.php',
        ]);
    }
}
