<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Routing\RouterInterface;

class HomeController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    public function index(RouterInterface $router): Response
    {
        $routes = array_filter(
            array_keys($router->getRouteCollection()->all()),
            fn (string $name) => str_starts_with($name, 'app_'),
        );

        return $this->render('home/index.html.twig', ['routes' => $routes]);
    }
}
