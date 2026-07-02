<?php

namespace App\Controller;

use App\Dto\PriceBcMathNumberDto;
use App\Form\PriceBcMathNumberType;
use App\Form\PriceNumberCallbackTransformerType;
use BcMath\Number;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Validator\Validator\ValidatorInterface;

class PriceBcMathNumberController extends AbstractController
{
    #[Route('/price/bcmath/form/number_callback_type', name: 'app_bcmath_form_number_callback_type')]
    public function index(Request $request): Response
    {
        $dto = new PriceBcMathNumberDto();
        $form = $this->createForm(PriceNumberCallbackTransformerType::class, $dto);
        $form->handleRequest($request);

        return $this->render('price/index.html.twig', [
            'title' => 'Prices with BcMath\Number type with NumberType',
            'form' => $form,
            'submitted' => $form->isSubmitted(),
            'valid' => $form->isSubmitted() && $form->isValid(),
        ]);
    }

    #[Route('/price/bcmath/form/bcmath_number_type', name: 'app_bcmath_form_bcmath_number_type')]
    public function customType(Request $request): Response
    {
        $dto = new PriceBcMathNumberDto();
        $form = $this->createForm(PriceBcMathNumberType::class, $dto);
        $form->handleRequest($request);

        return $this->render('price/index.html.twig', [
            'title' => 'Prices with BcMath\Number type with BcMathNumberType',
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
            'title' => 'Prices with BcMath\Number type — Direct Validation',
            'dto' => $dto,
            'violations' => $violations,
            'cases' => $cases,
        ]);
    }
}
