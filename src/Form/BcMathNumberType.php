<?php

namespace App\Form;

use BcMath\Number;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\CallbackTransformer;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class BcMathNumberType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder->addModelTransformer(
            new CallbackTransformer(
                fn (?Number $value): ?string => null !== $value ? (string) $value : null,
                fn (?string $value): ?Number => null !== $value && '' !== $value ? new Number($value) : null,
            )
        );
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'compound' => false,
        ]);
    }

    public function getBlockPrefix(): string
    {
        return 'bcmath_number';
    }
}
