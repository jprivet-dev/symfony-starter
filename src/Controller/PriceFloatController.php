<?php

namespace App\Controller;

use App\Dto\PriceBcMathNumberDto;
use App\Dto\PriceFloatDto;
use App\Form\PriceFloatType;
use BcMath\Number;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Validator\Validator\ValidatorInterface;

class PriceFloatController extends AbstractController
{
    #[Route('/price/float', name: 'app_float')]
    public function index(Request $request): Response
    {
        $dto = new PriceFloatDto();
        $form = $this->createForm(PriceFloatType::class, $dto);
        $form->handleRequest($request);

        return $this->render('price/index.html.twig', [
            'title' => 'Float — Form',
            'form' => $form,
            'submitted' => $form->isSubmitted(),
            'valid' => $form->isSubmitted() && $form->isValid(),
        ]);
    }

    #[Route('/price/float/violations', name: 'app_float_violations')]
    public function violations(ValidatorInterface $validator): Response
    {
        $cases = [
            'priceA' => ['initial' => '0.015', 'shouldBeValid' => true],
            'priceB' => ['initial' => '0.01', 'shouldBeValid' => true],
            'priceC' => ['initial' => '0.005', 'shouldBeValid' => false],
            'priceD' => ['initial' => '0.00999999999999999999', 'shouldBeValid' => false],
        ];

        $dto = new PriceFloatDto(
            priceA: 0.015,
            priceB: 0.01,
            priceC: 0.005,
            priceD: 0.00999999999999999999,
        );

        $violations = $validator->validate($dto);

        return $this->render('price/violations.html.twig', [
            'title' => 'Float — Direct Validation',
            'dto' => $dto,
            'violations' => $violations,
            'cases' => $cases,
        ]);
    }
}
