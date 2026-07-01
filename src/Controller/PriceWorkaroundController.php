<?php

namespace App\Controller;

use App\Dto\PriceFormDto;
use App\Dto\PriceWorkaroundDto;
use App\Form\PriceWorkaroundType;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\ObjectMapper\ObjectMapperInterface;
use Symfony\Component\Routing\Attribute\Route;

class PriceWorkaroundController extends AbstractController
{
    #[Route('/price/workaround', name: 'app_price_workaround')]
    public function index(Request $request, ObjectMapperInterface $mapper): Response
    {
        $formDto = new PriceFormDto();
        $form = $this->createForm(PriceWorkaroundType::class, $formDto);
        $form->handleRequest($request);

        $dto = null;
        if ($form->isSubmitted() && $form->isValid()) {
            $dto = $mapper->map($formDto, PriceWorkaroundDto::class);
        }

        return $this->render('price_workaround/index.html.twig', [
            'form' => $form,
            'submitted' => $form->isSubmitted(),
            'valid' => $form->isSubmitted() && $form->isValid(),
            'dto' => $dto,
        ]);
    }
}
