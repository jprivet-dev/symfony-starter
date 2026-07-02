<?php

namespace App\Controller;

use App\Dto\PriceBcMathNumberDto;
use App\Form\PriceBcMathNumberType;
use BcMath\Number;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Validator\Validator\ValidatorInterface;

class PriceBcMathNumberController extends AbstractController
{
    #[Route('/price/bcmath', name: 'app_bcmath')]
    public function index(Request $request): Response
    {
        $dto = new PriceBcMathNumberDto();
        $form = $this->createForm(PriceBcMathNumberType::class, $dto);
        $form->handleRequest($request);

        return $this->render('price/index.html.twig', [
            'title' => 'BcMath\Number — Form',
            'form' => $form,
            'submitted' => $form->isSubmitted(),
            'valid' => $form->isSubmitted() && $form->isValid(),
        ]);
    }

    #[Route('/price/bcmath/violations', name: 'app_bcmath_violations')]
    public function violations(ValidatorInterface $validator): Response
    {
        $cases = [
            'priceA' => ['initial' => '0.015', 'shouldBeValid' => true],
            'priceB' => ['initial' => '0.01', 'shouldBeValid' => true],
            'priceC' => ['initial' => '0.005', 'shouldBeValid' => false],
            'priceD' => ['initial' => '0.00999999999999999999', 'shouldBeValid' => false],
        ];

        $dto = new PriceBcMathNumberDto(
            priceA: new Number('0.015'),
            priceB: new Number('0.01'),
            priceC: new Number('0.005'),
            priceD: new Number('0.00999999999999999999'),
        );

        $violations = $validator->validate($dto);

        return $this->render('price/violations.html.twig', [
            'title' => 'BcMath\Number — Direct Validation',
            'dto' => $dto,
            'violations' => $violations,
            'cases' => $cases,
        ]);
    }
}
