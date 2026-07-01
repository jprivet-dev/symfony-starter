<?php

namespace App\Controller;

use App\Dto\PriceV1Dto;
use App\Dto\PriceV1MappingDto;
use App\Form\PriceV1Type;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\ObjectMapper\ObjectMapperInterface;
use Symfony\Component\Routing\Attribute\Route;

class PriceV1Controller extends AbstractController
{
    #[Route('/price/v1', name: 'app_price_v1')]
    public function index(Request $request, ObjectMapperInterface $mapper): Response
    {
        $formDto = new PriceV1Dto();
        $form = $this->createForm(PriceV1Type::class, $formDto);
        $form->handleRequest($request);

        $dto = null;
        if ($form->isSubmitted() && $form->isValid()) {
            $dto = $mapper->map($formDto, PriceV1MappingDto::class);
        }

        return $this->render('price_v1/index.html.twig', [
            'form' => $form,
            'submitted' => $form->isSubmitted(),
            'valid' => $form->isSubmitted() && $form->isValid(),
            'dto' => $dto,
        ]);
    }
}
