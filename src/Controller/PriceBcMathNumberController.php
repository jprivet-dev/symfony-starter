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
            [
                'label' => 'Valid',
                'initial_value' => '0.015',
                'dto' => new PriceBcMathNumberDto(new Number('0.015')),
                'status' => 'ok',
            ],
            [
                'label' => 'Invalid 1',
                'initial_value' => '0.005',
                'dto' => new PriceBcMathNumberDto(new Number('0.005')),
                'status' => 'ok',
            ],
            [
                'label' => 'Invalid 2',
                'initial_value' => '0.00999999999999999999',
                'dto' => new PriceBcMathNumberDto(new Number('0.00999999999999999999')),
                'status' => 'ok',
            ],
        ];

        foreach ($cases as &$case) {
            $case['violations'] = $validator->validate($case['dto']);
        }

        return $this->render('price/violations.html.twig', [
            'title' => 'BcMath\Number — Direct Validation',
            'cases' => $cases,
        ]);
    }
}
