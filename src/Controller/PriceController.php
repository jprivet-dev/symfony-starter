<?php

namespace App\Controller;

use App\Dto\PriceV0Dto;
use App\Form\PriceV0Type;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class PriceController extends AbstractController
{
    #[Route('/price/v0', name: 'app_price_v0')]
    public function v0(Request $request): Response
    {
        $dto = new PriceV0Dto();
        $form = $this->createForm(PriceV0Type::class, $dto);
        $form->handleRequest($request);

        return $this->render('price/index.html.twig', [
            'title' => 'BcMath\Number V0',
            'form' => $form,
            'submitted' => $form->isSubmitted(),
            'valid' => $form->isSubmitted() && $form->isValid(),
        ]);
    }
}
