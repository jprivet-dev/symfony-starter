<?php

namespace App\Form;

use App\Dto\PriceV0Dto;
use BcMath\Number;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\CallbackTransformer;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PriceV0Type extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        foreach (['priceA', 'priceB', 'priceC', 'priceD'] as $field) {
            $builder->add($field, NumberType::class);
            $builder->get($field)->addModelTransformer(new CallbackTransformer(
                fn (?Number $value): string => (string) ($value ?? ''),
                fn (?string $value): ?Number => null !== $value && '' !== $value ? new Number($value) : null,
            ));
        }
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => PriceV0Dto::class]);
    }
}
