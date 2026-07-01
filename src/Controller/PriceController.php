<?php

namespace App\Controller;

use App\Dto\PriceDto;
use App\Form\PriceType;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class PriceController extends AbstractController
{
    #[Route('/price', name: 'app_price')]
    public function index(Request $request): Response
    {
        $dto = new PriceDto();
        $form = $this->createForm(PriceType::class, $dto);
        $form->handleRequest($request);

        return $this->render('price/index.html.twig', [
            'form' => $form,
            'submitted' => $form->isSubmitted(),
            'valid' => $form->isSubmitted() && $form->isValid(),
            'dto' => $dto,
        ]);
    }
}
