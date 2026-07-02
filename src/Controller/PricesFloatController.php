<?php

namespace App\Controller;

use App\Dto\PricesFloatDto;
use App\Form\PricesNumberType;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Validator\Validator\ValidatorInterface;

class PricesFloatController extends AbstractController
{
    #[Route('/prices/float_form', name: 'app_float_form')]
    public function index(Request $request): Response
    {
        $dto = new PricesFloatDto();
        $form = $this->createForm(PricesNumberType::class, $dto);
        $form->handleRequest($request);

        return $this->render('prices/index.html.twig', [
            'title' => 'Prices with float type with NumberType',
            'form' => $form,
            'submitted' => $form->isSubmitted(),
            'valid' => $form->isSubmitted() && $form->isValid(),
        ]);
    }

    #[Route('/prices/float_violations', name: 'app_float_violations')]
    public function violations(ValidatorInterface $validator): Response
    {
        $cases = [
            'priceA' => ['initial' => '0.015', 'shouldBeValid' => true],
            'priceB' => ['initial' => '0.01', 'shouldBeValid' => true],
            'priceC' => ['initial' => '0.005', 'shouldBeValid' => false],
            'priceD' => ['initial' => '0.00999999999999999999', 'shouldBeValid' => false],
        ];

        $dto = new PricesFloatDto(
            priceA: 0.015,
            priceB: 0.01,
            priceC: 0.005,
            priceD: 0.00999999999999999999,
        );

        $violations = $validator->validate($dto);

        return $this->render('prices/violations.html.twig', [
            'title' => 'Prices with float type — Direct Validation',
            'dto' => $dto,
            'violations' => $violations,
            'cases' => $cases,
        ]);
    }
}
