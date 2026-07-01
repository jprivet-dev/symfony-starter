<?php

namespace App\Controller;

use App\Dto\PriceV2Dto;
use App\Form\PriceV2Type;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class PriceV2Controller extends AbstractController
{
    #[Route('/price/v2', name: 'app_price_v2')]
    public function index(Request $request): Response
    {
        $dto = new PriceV2Dto();
        $form = $this->createForm(PriceV2Type::class, $dto);
        $form->handleRequest($request);

        return $this->render('price_v2/index.html.twig', [
            'form' => $form,
            'submitted' => $form->isSubmitted(),
            'valid' => $form->isSubmitted() && $form->isValid(),
            'dto' => $dto,
        ]);
    }
}
